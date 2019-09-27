class CardsController < ApplicationController
  def show

  end

  private

  def cards_params
    params.require(:cards_params).permit(:id, :board_id, :start_date, :card_type)
  end
end
