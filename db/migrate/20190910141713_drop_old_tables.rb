class DropOldTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :actions
    drop_table :list_times
    drop_table :cards
  end
end
