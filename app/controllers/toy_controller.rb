class ToyController < ApplicationController
  include ToyHelper
  def index
    @board = Trello::AxolotlClient.new.board
    @actions = Trello::AxolotlClient.new.actions
    @lists = Trello::AxolotlClient.new.lists

    @lists.each do |list|
      puts 'List: ' + list['name']
      next unless list['name'] =~ /Done/i

      puts 'FETCHING CARDS IN DONE!'
      @list_cards = Trello::AxolotlClient.new.fetch_list_cards(list['id'])
      @list_cards.each do |card|
        trello_card = TrelloCard.find_by(trello_id: card['id'])
        puts 'Handling Card: ' + card['name']
        puts 'Card:' + trello_card.to_s

        if trello_card.nil?
          puts 'Creating New Card'
          trello_card = TrelloCard.create(trello_id: card['id'], name: card['name'])
        end

        @card_actions = Trello::AxolotlClient.new.fetch_card_actions(card['id'])

        @card_actions.each do |action|
          next unless TrelloAction.find_by(trello_id: action['id']).nil?

          trello_card.trello_actions.push(TrelloAction.new(:trello_id => action['id'],
                                                           :action_type => action['type'],
                                                           :datetime => action['date']))
          next if action['data']['listAfter'].nil?

          next unless TrelloListChange.find_by(trello_action_ref_id: action['data']['card']['id']).nil?

          trello_card.trello_list_changes.push(
              TrelloListChange.new(:datetime => action['date'],
                                   :list_before => action['data']['listBefore']['id'],
                                   :list_after => action['data']['listAfter']['id'],
                                   :list_before_name => action['data']['listBefore']['name'],
                                   :list_after_name => action['data']['listAfter']['name'],
                                   :trello_action_ref_id => action['id'])
          )
        end

        capture = trello_card.name.match(/^\((\d+)\)/)
        puts 'CAPTURE: ' + capture.to_s

        unless capture.nil?
          trello_card.points = capture[1]
        end

        trello_card.save

        i = 0
        until trello_card.trello_list_changes[i+1].nil?
          time_in_list = trello_card.trello_list_changes[i].datetime - trello_card.trello_list_changes[i+1].datetime
          trello_card.trello_list_changes[i+1].time_in_list = time_in_list
          trello_card.trello_list_changes[i+1].save
          i += 1
        end
      end
    end
  end
end

