class AddCardIdToAction < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :trello_card_id, :string
  end
end
