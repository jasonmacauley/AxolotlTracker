class AddUrlToTrelloBoard < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_boards, :url, :string
  end
end
