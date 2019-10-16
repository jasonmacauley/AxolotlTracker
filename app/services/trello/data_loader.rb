module Trello
  class DataLoader
    def initialize(trello_key, trello_token)
      @key = trello_key
      @token = trello_token
      @trello_client = Trello::TrelloClient.new(trello_key, trello_token)
    end

    def load_board_data(board)
      import_board_lists(board)
      import_board_labels(board)
    end

    def load_stat_data(board)
      load_all_board_stat_data(board)
    end

    def import_board_lists(board)
      lists = @trello_client.fetch_board_lists(board.trello_id)
      lists.each do |list|
        save_list(board, list)
      end
      save_list(board, {'name' => 'new', 'id' => 'none'})
      board.save
    end

    def import_board_labels(board)
      labels = @trello_client.fetch_board_labels(board.trello_id)
      labels.each do |label|
        board.trello_labels.push(
            TrelloLabel.create(name: label['name'], trello_id: label['id'])
        ) unless TrelloLabel.find_by_trello_id(label['id'])
      end
      board.save
    end

    private

    def load_all_board_stat_data(board)
      lists = [done_list(board)]
      burndowns = board.burndowns
      burndowns.each do |b|
        b.config_hash['to_do_lists'].each do |list|
          lists.push(list)
        end
      end
      handle_lists(board, lists)
    end

    def save_list(board, list)
      board.trello_lists.push(
          TrelloList.create(name: list['name'], trello_id: list['id'])
      ) unless TrelloList.find_by_trello_id(list['id'])
    end

    def handle_lists(board, lists)
      completed_lists = []
      lists.each do |list|
        next if completed_lists.select {|l| l.match?(/#{list}/)}.count > 0
        list.match?(/#{done_list(board)}/) ? state = 'dpne' : state = 'open'
        handle_list(board, list, state)
        completed_lists.push(list)
      end
    end

    def done_list(board)
      done_config = BoardConfiguration.config_by_board_type(board.id, 'done_list_id')
      done_config[0].value
    end

    def handle_list(board, list_id, state)
      list_cards = @trello_client.fetch_list_cards(list_id)
      list_cards.each do |card|
        card['state'] = state
        CardWorker.new(@key, @token).import_card(card, board)
      end
    end
  end
end
