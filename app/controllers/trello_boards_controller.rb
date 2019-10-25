class TrelloBoardsController < ApplicationController
  before_action :authenticate_user!
  include TrelloBoardsHelper
  def index
    @boards = TrelloBoard.all
  end

  def show
    @board = TrelloBoard.find(params[:id])
    @filter = Calculators::LabelFilter.new(@board)
    @filter.only_completed_cards = true
    @cards = @filter.filter_cards(@board.trello_cards)
    @mondays = get_mondays(20)
    @lists = calc_average_time_in_lists(@cards)
    @events_by_week = events_by_week
    @cards_by_week = []
    averages_by_week = historical_card_data
    @averages = get_trailing_average(@cards_by_week)
    @chart_data = build_throughput_chart_data(@cards_by_week)
    @trailing_average_period = trailing_average_period(@board)
    @list_average_data = build_list_average_display(averages_by_week)
    @avg_graph = time_in_list_graph_data(@list_average_data)
    ct_calc = Calculators::CycleTime.new(@board)
    @cycle_time = ct_calc.historical_cycle_time(averages_by_week)
    @avg_graph.push({name: 'cycle_time', data: @cycle_time})
    @burndowns = @board.burndowns
    @cycle_time_lists = ct_calc.lists
  end

  private

  def historical_card_data
    averages_by_week = {}
    calculator = Calculators::TimeInList.new(@board)
    @mondays.each do |monday|
      crunch_week_cards(monday, monday + 6.days)
      averages_by_week[monday] = calculator.calc_average_time_in_lists_for_period(monday, monday + 6.days)
    end
    averages_by_week
  end

  def events_by_week
    events = {}
    @mondays.each do |monday|
      events[monday] = Event.event_between_by_board(monday, monday + 6.days, @board.id)
    end
    return events
  end

  def get_mondays(count)
    mondays = [get_monday]
    i = 1
    while i <= count
      mondays.push(mondays[i-1] - 1.week)
      i += 1
    end
    return mondays
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
        data[date][list] = {}
        #binding.pry
        data[date][list]['average'] = averages[list] ? averages[list]['average'] : 0
      end
    end

    return data
  end

  def get_trailing_average(cards_by_week)
    Calculators::StatCalculator.new.trailing_average(cards_by_week, @board)
  end


  def trailing_average_period(board)
    configs = board.config_hash['trailing_average_period']
    configs.count > 0 ? configs[0].to_i : 5
  end

  def get_monday
    d = Date.today
    until d.monday?
      d = d - 1.day
    end
    return d
  end

  def crunch_week_cards(begin_date, end_date)
    w_cards = @filter.filter_cards(TrelloCard.last_action_between_by_board(begin_date, end_date, @board.id))
    spikes = @filter.filter_cards(TrelloCard.last_action_between_by_board_and_type(
        begin_date,
        end_date,
        @board.id, 'spike')).count
    airbrakes = @filter.filter_cards(TrelloCard.last_action_between_by_board_and_type(
        begin_date,
        end_date,
        @board.id,
        'airbrake')).count
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
    trailing_average_trend = Calculators::StatCalculator.new.trailing_average_trend(@cards_by_week, @board)
    chart_data = {}
    chart_data['throughput'] = [
        { name: 'cards', data: cards_s },
        { name: 'points', data: points_s },
        { name: 'spikes', data: spikes_s },
        { name: 'airbrakes', data: airbrakes_s },
        { name: 'points trend', data: trailing_average_trend['points'] },
        { name: 'card trend', data: trailing_average_trend['cards'] }
    ]
    return chart_data
  end

  def trello_board_params
    params.require(:trello_board_params).permit(:id)
  end

end
