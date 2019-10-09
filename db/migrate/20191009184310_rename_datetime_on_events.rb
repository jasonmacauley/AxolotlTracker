class RenameDatetimeOnEvents < ActiveRecord::Migration[5.1]
  def change
    rename_column :events, :datetime, :event_date
  end
end
