class AddUniqIndexToBurndown < ActiveRecord::Migration[5.1]
  def change
    add_index :burndowns, [:name, :trello_board_id], name: 'board_burndown'
  end
end
