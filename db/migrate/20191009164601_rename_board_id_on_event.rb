class RenameBoardIdOnEvent < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :board_id, :trello_board_id
  end
end
