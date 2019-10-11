class TrelloLabel < ApplicationRecord
  belongs_to :trello_board
  has_and_belongs_to_many :trello_cards
end
