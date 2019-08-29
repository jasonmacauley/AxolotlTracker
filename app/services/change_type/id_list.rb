module ChangeType
  class IdList
    def handle(action)
      puts 'ID List - ' + action['data'].to_s
      last = ListTime.find_by(trello_card_id: action['data']['card']['id'],
                              trello_list_id: action['data']['old']['idList']
      )

      if last.nil?
        ListTime.create(
            trello_card_id: action['data']['card']['id'],
            trello_list_id: action['data']['listBefore']['id'],
            exit: action['date']
        )
      else
        last.exit = action['date']
        last.save
      end

      after = ListTime.find_by(trello_card_id: action['data']['card']['id'],
                              trello_list_id: action['data']['listAfter']['id']
      )

      if after.nil?
        ListTime.create(
                    trello_card_id: action['data']['card']['id'],
                    trello_list_id: action['data']['listAfter']['id'],
                    enter: action['date']
        )
      else
        after.enter = action['date']
        after.save
      end
    end
  end
end
