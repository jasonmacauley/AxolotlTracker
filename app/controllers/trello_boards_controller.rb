class TrelloBoardsController < ApplicationController
  include TrelloBoardsHelper
  def index
    @boards = TrelloBoard.all
  end

  def show
    @board = TrelloBoard.find(params[:id])
    @cards = @board.trello_cards
    @lists = calc_average_time_in_lists(@cards)

    @cards_by_week = []
    averages_by_week = historical_card_data
    @averages = get_trailing_average(@cards_by_week)
    @chart_data = build_throughput_chart_data(@cards_by_week)
    @trailing_average_period = trailing_average_period
    @list_average_data = build_list_average_display(averages_by_week)
    @avg_graph = time_in_list_graph_data(@list_average_data)
    @cycle_time = Calculators::CycleTime.new(@board).historical_cycle_time(averages_by_week)
    puts 'AVG: ' + @avg_graph.to_s
    puts 'Cycle Time: ' + @cycle_time.to_s
    @avg_graph.push({name: 'cycle_time', data: @cycle_time})
  end

  private

  def historical_card_data
    monday = get_monday
    averages_by_week = {}
    crunch_week_cards(monday, Date.today)
    calculator = Calculators::TimeInList.new(@board)
    averages_by_week[monday] = calculator.calc_average_time_in_lists_for_period(monday, Date.today)
    wks = 0
    while wks < 20
      c_monday = monday - wks.weeks
      puts (c_monday - 1.weeks).to_s + ' -> ' + (c_monday - 1.day).to_s
      crunch_week_cards(c_monday - 1.week, c_monday - 1.day)
      averages_by_week[c_monday - 1.week] = calculator.calc_average_time_in_lists_for_period(c_monday - 1.week, c_monday - 1.day)
      wks += 1
    end
    averages_by_week
  end

  def time_in_list_graph_data(avg_time_data)
    avg_data = {}
    avg_time_data.each do |date, data|
      display_lists.each do |list|
        next if date.to_s.match?(/lists/)
        avg_data[list] = {} unless avg_data[list]
        avg_data[list]['data'] = {} unless avg_data[list]['data']
        avg_data[list]['name'] = list unless avg_data[list]['name']
        avg_data[list]['data'][date] = data[list]['average']
      end
    end
    avg_graph = []
    avg_data.each do |key, data|
      avg_graph.push(data)
    end
    return avg_graph
  end

  def display_lists
    display_list_config = BoardConfiguration.config_by_board_type(@board.id, 'display_average_lists')
    list = []
    return list unless display_list_config.count > 0
    display_list_config.each do |config|
      list.push(TrelloList.find_by_trello_id(config.value).name)
    end
    return list
  end

  def build_list_average_display(averages_by_week)
    data = {}
    data['lists'] = display_lists

    averages_by_week.each do |date, averages|
      data[date] = {}
      data['lists'].each do |list|
        puts 'LIST: ' + list
        data[date][list] = {}
        #binding.pry
        data[date][list]['average'] = averages[list] ? averages[list]['average'] : 0
      end
    end

    return data
  end

  def get_trailing_average(cards_by_week)
    period = trailing_average_period
    i = 1
    cards = 0
    points = 0
    while i < period + 1
      cards += cards_by_week[i][1]
      points += cards_by_week[i][2]
      i += 1
    end
    [cards / period, points / period]
  end

  def trailing_average_period
    configs = BoardConfiguration.config_by_board_type(@board.id, 'trailing_average_period')
    configs.count > 0 ? configs[0].value.to_i : 5
  end

  def get_monday
    d = Date.today
    until d.monday?
      d = d - 1.day
    end
    return d
  end

  def crunch_week_cards(begin_date, end_date)
    w_cards = TrelloCard.last_action_between_by_board(begin_date, end_date, @board.id)
    spikes = TrelloCard.last_action_between_by_board_and_type(
        begin_date,
        end_date,
        @board.id, 'spike').count
    airbrakes = TrelloCard.last_action_between_by_board_and_type(
        begin_date,
        end_date,
        @board.id,
        'airbrake').count
    c_count = 0
    p_count = 0
    w_cards.each do |card|
      c_count += 1
      p_count += card.points if card.points
    end
    @cards_by_week.push([begin_date, c_count, p_count, spikes, airbrakes])
  end

  def build_throughput_chart_data(cards_by_week)
    cards_s = {}
    points_s = {}
    spikes_s = {}
    airbrakes_s = {}

    cards_by_week.each do |date, cards, points, spikes, airbrakes|
      cards_s[date] = cards
      points_s[date] = points
      spikes_s[date] = spikes
      airbrakes_s[date] = airbrakes
    end
    chart_data = {}
    chart_data['throughput'] = [
        { name: 'cards', data: cards_s },
        { name: 'points', data: points_s },
        { name: 'spikes', data: spikes_s },
        { name: 'airbrakes', data: airbrakes_s }
    ]
    return chart_data
  end

  def trello_board_params
    params.require(:trello_board_params).permit(:id)
  end

end
