class ToyController < ApplicationController
  def index
    @board = Trello::AxolotlClient.new.board
    @actions = Trello::AxolotlClient.new.actions

    @actions.each do |action|
      act = Action.find_by_trello_id(action['id'])

      puts 'Action Type: ' + action['type']
      next unless action['data'].key?("card")

      if act.nil?
        Action.create(
                  trello_id: action['id'],
                  datetime: action['date'],
                  trello_card_id: action['data']['card']['id'],
                  action_type: action['type'],
                  change_type: action['data']['old']
        )
      end
    end
    @sorted_actions = Action.order(trello_card_id: :asc).order(datetime: :asc)
  end
end
