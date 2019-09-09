class UpdateListChangeAddColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_list_changes, :list_before_name, :string
    add_column :trello_list_changes, :list_after_name, :string
  end
end
