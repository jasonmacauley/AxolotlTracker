class TrelloCard < ApplicationRecord
  has_many :trello_actions
  has_many :trello_list_changes
  has_one :trello_list
  scope :last_action_between, lambda {|start_date, end_date|
    where('last_action_datetime >= ? AND last_action_datetime <= ?',
          start_date, end_date)}
end
