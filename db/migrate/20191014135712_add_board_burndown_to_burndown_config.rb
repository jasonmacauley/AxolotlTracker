class AddBoardBurndownToBurndownConfig < ActiveRecord::Migration[5.1]
  def change
    add_column :burndown_configs, :trello_board_id, :integer
    add_column :burndown_configs, :burndown_id, :integer
  end
end
