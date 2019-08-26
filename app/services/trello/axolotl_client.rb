module Trello
  class AxolotlClient < TrelloClient
    AX_ID = '5c114cf3d3b8e1120395a89a'.freeze
    def board
      fetch_board(AX_ID)
    end

    def actions
      fetch_board_actions(AX_ID)
    end
  end
end
