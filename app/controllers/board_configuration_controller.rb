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
    @lists = Trello::TrelloClient.new.fetch_board_lists(@board.trello_id)
  end

  def update
    @board = TrelloBoard.find(params[:id])
    save_config(@board, 'done_list_id', params[:done_list_id])
    save_config(@board, 'review_list_id', params[:review_list_id])

    redirect_to action: :edit, id: @board
  end

  private

  def save_config(board, config_type, value)
    board.board_configurations.each do |config|
      if config.config_type.match?(config_type)
        config.value = value
      end
    end
    unless BoardConfiguration.config_by_board_type(@board.id, config_type).count > 0
      config = BoardConfiguration.new('config_type' => config_type,
                                      'value' => value)
      config.save
      @board.board_configurations.push(config)
    end
    @board.save
  end

  def board_configuration_params
    params.require(:board_configuration_params).require(:trello_id, :id, :name, :done_list_id, :board_id, :review_list_id)
  end
end
