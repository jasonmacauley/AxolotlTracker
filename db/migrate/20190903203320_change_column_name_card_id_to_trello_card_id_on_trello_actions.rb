class ChangeColumnNameCardIdToTrelloCardIdOnTrelloActions < ActiveRecord::Migration[5.1]
  def change
    rename_column :trello_actions, :card_id, :trello_card_id
  end
end
