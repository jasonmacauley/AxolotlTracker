class CreateBoardConfigurations < ActiveRecord::Migration[5.1]
  def change
    create_table :board_configurations do |t|
      t.string :config_type
      t.string :value
      t.integer :board_id

      t.timestamps
    end
  end
end
