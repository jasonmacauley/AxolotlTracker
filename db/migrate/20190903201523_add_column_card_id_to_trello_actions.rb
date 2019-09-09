class AddColumnCardIdToTrelloActions < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_actions, :card_id, :integer
  end
end
