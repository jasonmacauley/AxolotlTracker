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
    @labels = Trello::TrelloClient.new.fetch_board_labels(@board.trello_id)
    tac = BoardConfiguration.config_by_board_type(@board.id, 'trailing_average_period')
    @trailing_average_period = tac.count > 0 ? tac[0].value : 5
  end

  def update
    @board = TrelloBoard.find(params[:id])
    save_config(@board, 'done_list_id', params[:done_list_id])
    save_config(@board, 'review_list_id', params[:review_list_id])
    save_config(@board, 'trailing_average_period', params[:trailing_average_period])
    save_checkbox_config(@board, 'cycle_time_lists', params[:cycle_time_lists])

    redirect_to action: :edit, id: @board
  end

  private

  def save_config(board, config_type, value)
    board.board_configurations.each do |config|
      if config.config_type.match?(config_type)
        config.value = value
        config.save
      end
    end
    unless BoardConfiguration.config_by_board_type(board.id, config_type).count > 0
      config = BoardConfiguration.new('config_type' => config_type,
                                      'value' => value)
      config.save
      board.board_configurations.push(config)
    end
    board.save
  end

  def save_checkbox_config(board, config_type, labels)
    current = BoardConfiguration.config_by_board_type(board.id,config_type)
    c_labels = {}
    current.each do |c_label|
      c_labels[c_label.value] = c_label
    end

    labels.each do |l|
      c_labels.delete(l) if c_labels[l]
    end

    c_labels.each do |k,v|
      board.board_configurations.delete(v)
    end

    puts 'VALUES ' + labels.to_s
    labels.each do |value|
      unless BoardConfiguration.config_by_board_type_value(board.id, config_type, value).count > 0
        config = BoardConfiguration.new('config_type' => config_type,
                                        'value' => value)
        config.save
        board.board_configurations.push(config)
      end
    end
    board.save
  end

  def board_configuration_params
    params.require(:board_configuration_params).require(:trello_id,
                                                        :id,
                                                        :name,
                                                        :done_list_id,
                                                        :board_id,
                                                        :review_list_id,
                                                        :filtered_labels,
                                                        :cycle_time_lists,
                                                        :trailing_average_period)
  end
end
