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

    five_days_cards = TrelloCard.last_action_between_by_board(1.week.ago, Time.now, @board.id)

    @recent_lists = calc_average_time_in_lists(five_days_cards)

    prior_week = TrelloCard.last_action_between_by_board(2.weeks.ago, 1.week.ago, @board.id)

    @p_week = calc_average_time_in_lists(prior_week)

    @cards_by_week = []
    monday = Time.now.next_week - 1.weeks
    w_cards = TrelloCard.last_action_between_by_board(monday, Time.now, @board.id)
    @cards_by_week.push(crunch_week_cards(monday, w_cards))
    wks = 1
    while wks < 20
      c_monday = monday - wks.weeks
      puts (c_monday - 1.weeks).to_s + ' -> ' + (c_monday- 1.day).to_s
      w_cards = TrelloCard.last_action_between_by_board(c_monday - 1.weeks, c_monday - 1.day, @board.id)
      @cards_by_week.push(crunch_week_cards(c_monday, w_cards))
      wks += 1
    end
  end

  private

  def crunch_week_cards(date, w_cards)
    c_count = 0
    p_count = 0
    w_cards.each do |card|
      c_count += 1
      p_count += card.points if card.points
    end
    return [date, c_count, p_count]
  end

  def trello_board_params
    trello_board_params = params.require(:trello_board_params).permit(:id)

  end

end
