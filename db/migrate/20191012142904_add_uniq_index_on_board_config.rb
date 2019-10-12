class AddUniqIndexOnBoardConfig < ActiveRecord::Migration[5.1]
  def change
    add_index :board_configurations, [:config_type, :value, :trello_board_id], unique: true, name: 'board_config'
  end
end
