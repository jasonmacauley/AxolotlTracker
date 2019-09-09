class AddColumnPointsToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :points, :integer
  end
end
