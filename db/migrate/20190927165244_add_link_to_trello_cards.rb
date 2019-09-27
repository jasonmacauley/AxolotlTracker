class AddLinkToTrelloCards < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :trello_link, :string
  end
end
