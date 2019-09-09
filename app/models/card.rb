class Card < ApplicationRecord
  def actions
    Action.where(trello_card_id: this.trello_id)
  end
end
