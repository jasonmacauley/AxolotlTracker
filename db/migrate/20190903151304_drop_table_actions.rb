class DropTableActions < ActiveRecord::Migration[5.1]
  def change
    drop_table :actions
    drop_table :cards
    drop_table :list_times
  end
end
