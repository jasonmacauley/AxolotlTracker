class AddForeignKeyToAction < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :trello_cards, :trello_actions
  end
end
