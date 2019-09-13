class ToyController < ApplicationController
  include ToyHelper
  BOARDS = ['5c114cf3d3b8e1120395a89a',
            '5ac3b828260d6feb6cb0ff4c',
            '5a67b76310cf303723d19928'].freeze
  def index
    BOARDS.each do |board_id|
      t_board = Trello::TrelloClient.new.fetch_board(board_id)

      TrelloBoard.create(trello_id: t_board['id'], name: t_board['name']) unless TrelloBoard.find_by(trello_id: board_id)

      board = TrelloBoard.find_by(trello_id: board_id)

      handle_lists(Trello::TrelloClient.new.fetch_board_lists(board_id), board)
    end
    @boards = Trello::TrelloClient.new.fetch_boards


  end

  private

  def handle_lists(lists, board)
    lists.each do |list|
      puts 'List: ' + list['name']
      next unless list['name'] =~ /Done/i

      puts 'FETCHING CARDS IN DONE!'
      list_cards = Trello::TrelloClient.new.fetch_list_cards(list['id'])
      list_cards.each do |card|
        trello_card = store_card(card)
        board.trello_cards.push(trello_card)
        import_actions(trello_card)
        card_last_action(trello_card)
      end
    end
  end

  def import_actions(trello_card)
    card_actions = Trello::TrelloClient.new.fetch_card_actions(trello_card.trello_id)

    card_actions.each do |action|
      store_action(trello_card, action)
      store_list_changes(trello_card, action)
    end

    calc_card_time_in_list(trello_card)
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

  def store_action(trello_card, action)
    return unless TrelloAction.find_by(trello_id: action['id']).nil?

    trello_card.trello_actions.push(TrelloAction.new(:trello_id => action['id'],
                                                     :action_type => action['type'],
                                                     :datetime => action['date']))
  end

  def store_card(card)
    trello_card = TrelloCard.find_by(trello_id: card['id'])
    puts 'Handling Card: ' + card['name']
    puts 'Card:' + trello_card.to_s

    if trello_card.nil?
      puts 'Creating New Card'
      trello_card = TrelloCard.create(trello_id: card['id'], name: card['name'])
    end
    get_point_value(trello_card)


    trello_card
  end

  def get_point_value(trello_card)
    capture = trello_card.name.match(/^\((\d+)\)/)

    unless capture.nil?
      trello_card.points = capture[1]
    end
  end

  def calc_card_time_in_list(trello_card)
    i = 0
    until trello_card.trello_list_changes[i + 1].nil?
      time_in_list = trello_card.trello_list_changes[i].datetime - trello_card.trello_list_changes[i + 1].datetime
      trello_card.trello_list_changes[i + 1].time_in_list = time_in_list
      trello_card.trello_list_changes[i + 1].save
      i += 1
    end
    trello_card.save
  end

  def card_last_action(trello_card)
    unless trello_card.trello_list_changes[0].nil?
      trello_card.last_action_datetime = trello_card.trello_list_changes[0].datetime
      trello_card.save
    end
  end
end

