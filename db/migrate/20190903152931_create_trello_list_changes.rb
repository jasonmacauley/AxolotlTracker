class CreateTrelloListChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :trello_list_changes do |t|
      t.string :trello_id
      t.string :change_type
      t.datetime :datetime

      t.timestamps
    end
  end
end
