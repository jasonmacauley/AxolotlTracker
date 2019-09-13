class AddBoardTrelloCard < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :board_trello_id, :string
    add_column :trello_cards, :board_name, :string
  end
end
