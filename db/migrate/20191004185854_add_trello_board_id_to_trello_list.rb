class AddTrelloBoardIdToTrelloList < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_lists, :trello_board_id, :integer
  end
end
