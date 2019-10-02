class BoardConfigurationController < ApplicationController
  def new
    @board = TrelloBoard.new
    trello_id = params[:trello_id]
    if TrelloBoard.find_by_trello_id(trello_id)
      redirect_to action: :edit, id: TrelloBoard.find_by_trello_id(trello_id)
    end
    @t_board = Trello::TrelloClient.new.fetch_board(trello_id)
    @board.trello_id = trello_id
    @board.name = @t_board['name']
    @board.save
    redirect_to action: :edit, id: TrelloBoard.find_by_trello_id(trello_id)
  end

  def show
  end

  def index
    @boards = Trello::TrelloClient.new.fetch_boards
  end

  def edit
    @board = TrelloBoard.find(params[:id])
  end

  def update
  end

  private

  def board_configuration_params
    params.require(:board_configuration_params).require(:trello_id, :id, :name)
  end
end
