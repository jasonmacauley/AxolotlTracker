class ChangeTypeToCardTypeOnTrelloCard < ActiveRecord::Migration[5.1]
  def change
    rename_column :trello_cards, :type, :card_type
  end
end
