class CreateTrelloBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :trello_boards do |t|
      t.string :trello_id
      t.string :name

      t.timestamps
    end
  end
end
