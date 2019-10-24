class BoardConfigurationController < ApplicationController
  before_action :authenticate_user!
  def new
    @board = TrelloBoard.new
    trello_id = params[:trello_id]
    if TrelloBoard.find_by_trello_id(trello_id)
      redirect_to action: :edit, id: TrelloBoard.find_by_trello_id(trello_id)
    end
    @t_board = trello_client.fetch_board(trello_id)
    @board.trello_id = trello_id
    @board.name = @t_board['name']
    @board.save
    update_board_data
    redirect_to action: :edit, id: TrelloBoard.find_by_trello_id(trello_id)
  end

  def show
  end

  def index
    @boards = trello_client.fetch_boards
  end

  def edit
    @board = TrelloBoard.find(params[:id])
    update_board_data
    @lists = @board.trello_lists
    @labels = @board.trello_labels
    tac = current_configs(@board, 'trailing_average_period')
    @trailing_average_period = tac.nil? ? 5 : tac
  end

  def update
    @board = TrelloBoard.find(params[:id])
    save_config(@board, 'done_list_id', params[:done_list_id])
    save_config(@board, 'review_list_id', params[:review_list_id])
    save_config(@board, 'trailing_average_period', params[:trailing_average_period])
    save_checkbox_config(@board, 'cycle_time_lists', params[:cycle_time_lists])
    save_checkbox_config(@board, 'display_average_lists', params[:display_average_lists])
    save_checkbox_config(@board, "filtered_labels", params[:filtered_labels])

    redirect_to action: :edit, id: @board
  end

  private

  def update_board_data
    data_loader.load_board_data(@board)
  end

  def save_config(board, config_type, value)
    board.board_configurations.each do |config|
      if config.config_type.match?(config_type)
        config.value = value
        config.save
        return
      end
    end
    unless current_configs(board, config_type).count > 0
      config = BoardConfiguration.new('config_type' => config_type,
                                      'value' => value)
      config.save
      board.board_configurations.push(config)
    end
    board.save
  end

  def save_checkbox_config(board, config_type, values)
    values = [] unless values
    current_configs(board, config_type).each do |config|
      next if values.select { |v| config.match?(/#{v}/) }.count > 0
      board.board_configurations.delete(config)
      config.delete
    end

    if values
      values.each do |value|
        next if current_configs(board, config_type).select { |config| config.match?(/#{value}/) }.count > 0
        config = BoardConfiguration.new('config_type' => config_type,
                                        'value' => value)
        config.save
        board.board_configurations.push(config)
      end
    end
    board.save
  end

  def current_configs(board, config_type)
    return board.config_hash[config_type].nil? ? [] : board.config_hash[config_type]
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
                                                        :trailing_average_period,
                                                        :display_average_lists)
  end

  def data_loader
    Trello::DataLoader.new(current_user.trello_credential.trello_key,
                             current_user.trello_credential.trello_token)
  end

end
