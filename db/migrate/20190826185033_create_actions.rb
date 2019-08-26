class CreateActions < ActiveRecord::Migration[5.1]
  def change
    create_table :actions do |t|
      t.string :trello_id
      t.datetime :datetime
      t.string :type
      t.string :change_type

      t.timestamps
    end
  end
end
