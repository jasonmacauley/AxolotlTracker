class CreateJoinTableCardsLabels < ActiveRecord::Migration[5.1]
  def change
    create_join_table :trello_cards, :trello_labels do |t|
      t.index [:trello_card_id, :trello_label_id], :unique => true,
              :name => 'card_label_join'
      # t.index [:trello_label_id, :trello_card_id]
    end
  end
end
