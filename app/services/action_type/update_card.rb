module ActionType
  class UpdateCard
    def handle(action)
      puts 'UpdateCard - ' + action['type']

      act = Action.find_by_trello_id(action['id'])

      puts 'Action Type: ' + action['type']
      return unless action['data'].key?('card')
      if act.nil?
        Action.create(
            trello_id: action['id'],
            datetime: action['date'],
            trello_card_id: action['data']['card']['id'],
            action_type: action['type'],
            change_type: action['data']['old']
        )
      end
      ChangeType::ChangeType.new.handle(action)
    end

  end
end
