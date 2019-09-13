class AddTrelloBoardIdToTrelloCards < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :trello_board_id, :integer
  end
end
