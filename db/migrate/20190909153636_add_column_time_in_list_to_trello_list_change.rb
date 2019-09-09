class AddColumnTimeInListToTrelloListChange < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_list_changes, :time_in_list, :decimal
  end
end
