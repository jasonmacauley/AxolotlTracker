class TrelloBoardsController < ApplicationController
  include TrelloBoardsHelper
  def index
    @boards = TrelloBoard.all
  end

  def show
    @board = TrelloBoard.find(params[:id])
    puts 'Board ID: ' + @board.id.to_s
    @cards = @board.trello_cards
    @lists = calc_average_time_in_lists(@cards)
    #binding.pry
    monday = get_monday
    five_days_cards = TrelloCard.last_action_between_by_board(monday - 1.week, monday, @board.id)

    @recent_lists = calc_average_time_in_lists(five_days_cards)

    prior_week = TrelloCard.last_action_between_by_board(monday - 2.weeks, monday - 1.weeks, @board.id)

    @p_week = calc_average_time_in_lists(prior_week)

    @cards_by_week = []
    crunch_week_cards(monday, Date.today)
    wks = 0
    while wks < 20
      c_monday = monday - wks.weeks
      puts (c_monday - 1.weeks).to_s + ' -> ' + (c_monday- 1.day).to_s
      crunch_week_cards(c_monday - 1.week, c_monday - 1.day)
      wks += 1
    end
    @averages = get_trailing_average(@cards_by_week)
    @chart_data = build_chart_data(@cards_by_week)
  end

  private

  def get_trailing_average(cards_by_week)
    i = 0
    cards = 0
    points = 0
    while i < 5
      cards += cards_by_week[i][1]
      points += cards_by_week[i][2]
      i += 1
    end
    [cards / 5, points / 5]
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

  def build_chart_data(cards_by_week)
    chart_data = {
        'cards' => {},
        'points' => {},
        'spikes' => {},
        'airbrakes' => {}
    }
    cards_by_week.each do |date, cards, points, spikes, airbrakes|
      chart_data['cards'][date] = cards
      chart_data['points'][date] = points
      chart_data['spikes'][date] = spikes
      chart_data['airbrakes'][date] = airbrakes
    end
    return chart_data
  end

  def trello_board_params
    params.require(:trello_board_params).permit(:id)
  end

end
