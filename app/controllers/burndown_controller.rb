class BurndownController < ApplicationController
  def index
    @board = TrelloBoard.find(params[:board_id])
    @burndowns = @board.burndowns
  end

  def show
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
    configs = @burndown.config_hash
    @chart_data = build_burndown_data(configs)
  end

  def create
    @board = TrelloBoard.find(params[:board_id])
    @burndown = Burndown.create(name: params[:burndown][:name], cards_per_week: params[:burndown][:cards_per_week])
    @board.burndowns.push(@burndown)

    save_checkbox_config(@burndown, 'to_do_lists', params[:burndown][:to_do_lists])
    save_checkbox_config(@burndown, 'milestone_labels', params[:burndown][:milestone_labels])
    redirect_to burndowns_path(@board)
  end

  def new
    @board = TrelloBoard.find(params[:board_id])
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
    redirect_to burndowns_path(@board)
  end

  def edit
    @burndown = Burndown.find(params[:id])
    @board = TrelloBoard.find(@burndown.trello_board_id)
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
  
  def build_burndown_data(configs)
    cards = get_matching_cards_by_date(configs)
    #binding.pry
    keys = cards['created'].keys
    return {} if keys.count == 0
    sorted = keys.sort
    data = {}
    days = []
    working_day = sorted[0]

    while working_day < Date.tomorrow
      if data[working_day - 1.day].nil?
        cards['created'][working_day].nil? ?
            data[working_day] = 0 :
            data[working_day] = cards['created'][working_day].count

        data[working_day] -= cards['done'][working_day].count unless cards['done'][working_day].nil?
      else
        cards['created'][working_day].nil? ?
            data[working_day] = data[working_day - 1.day] :
            data[working_day] = data[working_day - 1.day] + cards['created'][working_day].count

        data[working_day] -= cards['done'][working_day].count unless cards['done'][working_day].nil?
      end
      days.push(working_day)
      break if data[working_day] == 0
      working_day = working_day + 1.day
    end

    last_30 = days.pop(30)
    trimmed = {}
    last_30.each do |day|
      trimmed[day] = data[day]
    end

    burndown_data = [{name: 'Actual', data: trimmed}]
    puts "Data => " + burndown_data.to_s
    return burndown_data
  end

  def get_matching_cards_by_date(configs)
    cards_by_date = { 'done' => {}, 
                      'created' => {},
                      'count' => 0
    }
    configs['milestone_labels'].each do |label|
      t_label = TrelloLabel.where(trello_id: label)[0]
      cards = t_label.trello_cards
      cards.each do |card|
        cards_by_date['count'] += 1
        cards_by_date['done'][card.last_action_datetime.to_date].nil? ?
            cards_by_date['done'][card.last_action_datetime.to_date] = [card] :
            cards_by_date['done'][card.last_action_datetime.to_date].push(card) if card.state.match?('done')
        card.trello_create_date = card.last_action_datetime.to_date if card.trello_create_date.nil?
        cards_by_date['created'][card.trello_create_date].nil? ?
            cards_by_date['created'][card.trello_create_date] = [card] :
            cards_by_date['created'][card.trello_create_date].push(card)
      end
    end
    return cards_by_date
  end

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

  def trello_client
    Trello::TrelloClient.new(current_user.trello_credential.trello_key,
                             current_user.trello_credential.trello_token)
  end

  def current_configs(burndown, config_type)
    BurndownConfig.config_by_burndown_type(burndown.id, config_type)
  end

  def burndown_params
    params.require(:refresh_params).require(:id, :board_id)
  end
end
