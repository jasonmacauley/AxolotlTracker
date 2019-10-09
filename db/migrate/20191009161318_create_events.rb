class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.datetime :datetime
      t.string :description

      t.timestamps
    end
  end
end
