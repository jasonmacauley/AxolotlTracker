class AddLastRefreshToTrelloBoard < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_boards, :last_refresh, :datetime
  end
end
