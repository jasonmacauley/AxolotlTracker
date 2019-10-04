module Trello
  class TrelloClient
    TOKEN = '72c97d8476276c7e9758f617b5a01bcb9184d0b966b2d5757013253ced6dfbd1'.freeze
    KEY = 'cc752e29f0aa19eff1fb21e07eba0365'.freeze
    BASE_URL = 'https://api.trello.com/1/'.freeze

    def fetch_boards
      url = BASE_URL + 'members/me/boards?'
      do_get_request(url)
    end

    def fetch_board(board_id)
      url = board_url(board_id) + '?'
      do_get_request(url)
    end

    def fetch_board_actions(board_id)
      url = board_url(board_id) + '/actions?limit=1000&'
      do_get_request(url)
    end

    def fetch_board_labels(board_id)
      url = board_url(board_id) + '/labels?'
      do_get_request(url)
    end

    def fetch_card_actions(card_id)
      url = card_url(card_id) + '/actions?filter=all&'
      do_get_request(url)
    end

    def fetch_board_lists(board_id)
      url = board_url(board_id) + '/lists?'
      do_get_request(url)
    end

    def fetch_list_cards(list_id)
      url = list_url(list_id) + '/cards?'
      do_get_request(url)
    end

    def fetch_card(card_id)
      url = card_url(card_id) + '?'
      do_get_request(url)
    end

    private

    def do_get_request(url)
      cred_url = url + creds
      puts 'URL => ' + cred_url
      response = RestClient::Request.new(
          :method => :get,
          :url => cred_url
      ).execute
      JSON.parse(response.to_str)
    end

    def board_url(id)
      BASE_URL + 'boards/' + id.to_s
    end

    def card_url(id)
      BASE_URL + 'cards/' +id.to_s
    end

    def list_url(id)
      BASE_URL + 'lists/' +id.to_s
    end

    def creds
      'key=' + KEY + '&token=' + TOKEN
    end
  end
end
