class CreateListTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :list_times do |t|
      t.string :trello_card_id
      t.decimal :hours_in_list
      t.string :trello_list_id

      t.timestamps
    end
  end
end
