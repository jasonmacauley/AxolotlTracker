class CreateTrelloLabels < ActiveRecord::Migration[5.1]
  def change
    create_table :trello_labels do |t|
      t.integer :trello_board_id
      t.string :trello_id
      t.string :name

      t.timestamps
    end
  end
end
