class CreateTrelloCredentials < ActiveRecord::Migration[5.1]
  def change
    create_table :trello_credentials do |t|
      t.string :trello_key
      t.string :trello_token
      t.integer :user_id

      t.timestamps
    end
  end
end
