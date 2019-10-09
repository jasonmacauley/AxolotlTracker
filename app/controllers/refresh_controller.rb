class RefreshController < ApplicationController
  before_action :authenticate_user!
  def refresh
    @board = TrelloBoard.find(params[:id])
    refresh_board(@board) if @board
    redirect_to(trello_board_path(@board))
  end

  def refresh_all
    @t_boards = TrelloBoard.all
    @t_boards.each(&method(:refresh_board))
    redirect_to(trello_boards_path)
  end

  private

  def refresh_board(board)
    Trello::DataLoader.new(current_user.trello_credential.trello_key,
                           current_user.trello_credential.trello_token).load_board_data(board)
    board.last_refresh = Time.now
    board.save
  end

  def refresh_params
    params.require(:refresh_params).require(:id)
  end
end
