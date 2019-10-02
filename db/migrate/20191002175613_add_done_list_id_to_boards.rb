class AddDoneListIdToBoards < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_boards, :done_list_id, :string
  end
end
