class AddLastActivityToAction < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_cards, :last_action_datetime, :datetime
  end
end
