class AddTypeToTrelloCard < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :type, :string
  end
end
