module Trello
  class CardWorker
    def initialize(trello_key, trello_token)
      @trello_client = Trello::TrelloClient.new(trello_key, trello_token)
    end

    def import_card(trello_card, trello_board)
      handle_card(trello_board, trello_card)
    end

    private

    def handle_card(board, card)
      trello_card = store_card(card)

      return if trello_card.nil?

      board.trello_cards.push(trello_card)
      trello_card.save
    end

    def store_card(card)
      trello_card = TrelloCard.find_by(trello_id: card['id'])
      if card['closed'] && !card['state'].eql?('done')
        trello_card.delete unless trello_card.nil?
        return
      end

      create = false

      if trello_card.nil?
        trello_card = TrelloCard.create(
            trello_id: card['id'],
            name: card['name'])
        create = true
      end
      store_labels(card, trello_card)
      trello_card.name = card['name']
      trello_card.trello_link = card['url']
      trello_card.state = card['state']
      get_point_value(trello_card)
      get_card_type(trello_card)
      trello_card.save

      return trello_card if !trello_card.nil? && trello_card.updated_at > card['dateLastActivity'] && !create
      import_actions(trello_card)
      card_last_action(trello_card)

      trello_card.save
      trello_card
    end

    def store_labels(card, trello_card)
      labels = []
      card['labels'].each do |label|
        trello_label = TrelloLabel.find_by_trello_id(label['id'])
        next unless trello_label
        labels.push(trello_label)
        trello_card.trello_labels = labels
      end
    end

    def import_actions(trello_card)
      card_actions = @trello_client.fetch_card_list_actions(trello_card.trello_id)

      card_actions.each do |action|
        store_action(trello_card, action)
        store_list_changes(trello_card, action)
      end
    end

    def card_last_action(trello_card)
      return if trello_card.list_changes.last.nil?
      trello_card.last_action_datetime = trello_card.list_changes.last.datetime
      trello_card.save
    end

    def store_action(trello_card, action)
      return unless TrelloAction.find_by(trello_id: action['id']).nil?

      trello_card.trello_actions.push(TrelloAction.new(:trello_id => action['id'],
                                                       :action_type => action['type'],
                                                       :datetime => action['date']))
      if action['type'].match?(/createCard/)
        action['data']['listBefore'] = { 'id' => 'none',
                                         'name' => 'created'
                                        }
        action['data']['listAfter'] = { 'id' => action['data']['list']['id'],
                                        'name' => action['data']['list']['name']
                                      }
        trello_card.trello_create_date = action['date']
        trello_card.save
      end
    end

    def store_list_changes(trello_card, action)
      return if action['data']['listAfter'].nil?

      return unless TrelloListChange.find_by(trello_action_ref_id: action['id']).nil?

      trello_card.trello_list_changes.push(
          TrelloListChange.new(:datetime => action['date'],
                               :list_before => action['data']['listBefore']['id'],
                               :list_after => action['data']['listAfter']['id'],
                               :list_before_name => action['data']['listBefore']['name'],
                               :list_after_name => action['data']['listAfter']['name'],
                               :trello_action_ref_id => action['id'])
      )
    end

    def get_point_value(trello_card)
      capture =  trello_card.name.match(/^</) ? trello_card.name.match(/^<(\d+)/) : trello_card.name.match(/^\((\d+)\)/)

      unless capture.nil?
        trello_card.points = capture[1]
      end
    end

    def get_card_type(trello_card)
      if trello_card.name.match(/spike/i)
        trello_card.card_type = 'spike'
      elsif trello_card.name.match(/airbrake/i)
        trello_card.card_type = 'airbrake'
      else
        trello_card.card_type = 'product'
      end
    end

  end
end
