class TrelloCard < ApplicationRecord
  has_many :trello_actions
  has_many :trello_list_changes
  has_one :trello_list
end
