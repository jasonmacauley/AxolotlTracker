class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string :trello_id
      t.string :name
      t.string :current_trello_list_id

      t.timestamps
    end
  end
end
