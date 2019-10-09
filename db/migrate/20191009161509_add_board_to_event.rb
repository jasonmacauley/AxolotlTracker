class AddBoardToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :board_id, :integer
  end
end
