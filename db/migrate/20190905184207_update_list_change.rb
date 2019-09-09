class UpdateListChange < ActiveRecord::Migration[5.1]
  def change
    add_column :trello_list_changes, :trello_card_id, :integer
    add_column :trello_list_changes, :list_before, :string
    add_column :trello_list_changes, :list_after, :string
    add_column :trello_list_changes, :trello_action_ref_id, :string
    remove_columns :trello_list_changes, :trello_id, :change_type
  end
end
