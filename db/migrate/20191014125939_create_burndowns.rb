class CreateBurndowns < ActiveRecord::Migration[5.1]
  def change
    create_table :burndowns do |t|
      t.integer :trello_board_id
      t.timestamps
    end
  end
end
