module ActionType
  class CreateCard
    def handle(action)
      puts 'CreateCard - ' + action['type']
      return unless action['data'].key?('card')

      act = TrelloAction.find_by(trello_id: action['id'])


      puts 'Action Type: ' + action['type']


      if act.nil?
        TrelloAction.create(
            trello_id: action['id'],
            datetime: action['date'],
            trello_card_id: action['data']['card']['id'],
            action_type: action['type'],
            change_type: action['data']['old']
        )
      end

      after = ListTime.find_by(trello_card_id: action['data']['card']['id'],
                               trello_list_id: action['data']['list']['id']
      )

      if after.nil?
        ListTime.create(
            trello_card_id: action['data']['card']['id'],
            trello_list_id: action['data']['list']['id'],
            enter: action['date']
        )
      else
        after.enter = action['date']
        after.save
      end
    end
  end
end
