class CardsController < ApplicationController
  def show
    @cards = get_cards
  end

  private

  def get_cards
    if params[:card_type]
      TrelloCard.last_action_between_by_board_and_type(
          params[:start_date],
          Date.parse(params[:start_date]) + 1.week,
          params[:board_id], params[:card_type])
    else
      TrelloCard.last_action_between_by_board(
          params[:start_date],
          Date.parse(params[:start_date]) + 1.week,
          params[:board_id])
    end
  end

  def cards_params
    params.require(:cards_params).permit(:id, :board_id, :start_date, :card_type)
  end
end
