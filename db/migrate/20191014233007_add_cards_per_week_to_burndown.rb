class AddCardsPerWeekToBurndown < ActiveRecord::Migration[5.1]
  def change
    add_column :burndowns, :cards_per_week, :integer
  end
end
