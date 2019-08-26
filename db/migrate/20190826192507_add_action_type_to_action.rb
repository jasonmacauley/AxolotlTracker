class AddActionTypeToAction < ActiveRecord::Migration[5.1]
  def change
    add_column :actions, :action_type, :string
  end
end
