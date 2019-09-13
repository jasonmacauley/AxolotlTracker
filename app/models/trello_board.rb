class TrelloBoard < ApplicationRecord
  has_many :trello_cards
end
