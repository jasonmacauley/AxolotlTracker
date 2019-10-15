class AddCreatedAndStateToTrelloCard < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :trello_create_date, :date
    add_column :trello_cards, :state, :string
  end
end
