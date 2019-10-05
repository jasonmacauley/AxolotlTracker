class TrelloBoard < ApplicationRecord
  has_many :trello_cards
  has_many :board_configurations
  has_many :trello_lists
end
