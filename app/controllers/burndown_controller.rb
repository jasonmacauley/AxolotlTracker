class BurndownController < ApplicationController
  def index
    @board = TrelloBoard.find(params[:board_id])
    @burndowns = @board.burndowns
  end

  def show
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
    configs = @burndown.config_hash
    @chart_data = Calculators::Burndown.new.build_burndown_data(configs)
  end

  def create
    @board = TrelloBoard.find(params[:board_id])
    @burndown = Burndown.create(name: params[:burndown][:name], cards_per_week: params[:burndown][:cards_per_week])
    @board.burndowns.push(@burndown)

    save_checkbox_config(@burndown, 'to_do_lists', params[:burndown][:to_do_lists])
    save_checkbox_config(@burndown, 'milestone_labels', params[:burndown][:milestone_labels])
    redirect_to refresh_path(@board)
  end

  def new
    @board = TrelloBoard.find(params[:board_id])
    dataloader.load_board_data(@board)
    @burndown = Burndown.new
    @lists = @board.trello_lists
    @labels = @board.trello_labels
  end

  def update
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
    @burndown.name = params[:burndown][:name]
    @burndown.cards_per_week = params[:burndown][:cards_per_week]
    save_checkbox_config(@burndown, 'to_do_lists', params[:burndown][:to_do_lists])
    save_checkbox_config(@burndown, 'milestone_labels', params[:burndown][:milestone_labels])
    @burndown.save
    redirect_to(burndown_path(@burndown))
  end

  def edit
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
    dataloader.load_board_data(@board)
    @lists = @board.trello_lists
    @labels = @board.trello_labels
  end

  def destroy
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
    @burndown.delete
    redirect_to burndowns_path(@board)
  end

  private

  def save_checkbox_config(burndown, config_type, values)
    values = [] unless values
    current_configs(burndown, config_type).each do |config|
      next if values.select { |v| config.value.match?(/#{v}/) }.count > 0
      burndown.burndown_configs.delete(config)
      config.delete
    end

    if values
      values.each do |value|
        next if current_configs(burndown, config_type).select { |config| config.value.match?(/#{value}/) }.count > 0
        config = BurndownConfig.new('config_type' => config_type,
                                        'value' => value)
        config.save
        burndown.burndown_configs.push(config)
      end
    end
    burndown.save
  end

  #def trello_client
  #  Trello::TrelloClient.new(current_user.trello_credential.trello_key,
  #                           current_user.trello_credential.trello_token)
  #end
  #

  def dataloader
    Trello::DataLoader.new(current_user.trello_credential.trello_key,
                            current_user.trello_credential.trello_token)
  end

  def current_configs(burndown, config_type)
    BurndownConfig.config_by_burndown_type(burndown.id, config_type)
  end

  def burndown_params
    params.require(:refresh_params).require(:id, :board_id)
  end
end
