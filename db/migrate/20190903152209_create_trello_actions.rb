class CreateTrelloActions < ActiveRecord::Migration[5.1]
  def change
    create_table :trello_actions do |t|
      t.string :trello_id
      t.string :action_type
      t.string :update_type
      t.datetime :datetime

      t.timestamps
    end
  end
end
