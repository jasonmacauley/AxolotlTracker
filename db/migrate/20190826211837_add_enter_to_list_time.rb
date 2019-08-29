class AddEnterToListTime < ActiveRecord::Migration[5.1]
  def change
    add_column :list_times, :enter, :datetime
    add_column :list_times, :exit, :datetime
  end
end
