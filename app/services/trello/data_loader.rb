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
      handle_lists(board)
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

    def save_list(board, list)
      board.trello_lists.push(
          TrelloList.create(name: list['name'], trello_id: list['id'])
      ) unless TrelloList.find_by_trello_id(list['id'])
    end

    def handle_lists(board)
      done_config = BoardConfiguration.config_by_board_type(board.id, 'done_list_id')
      list_cards = @trello_client.fetch_list_cards(done_config[0].value)
      list_cards.each do |card|
        CardWorker.new(@key, @token).import_card(card, board)
      end
    end
  end
end
