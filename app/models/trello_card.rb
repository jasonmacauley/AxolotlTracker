class TrelloCard < ApplicationRecord
  has_many :trello_actions
  has_many :trello_list_changes
  has_one :trello_list
  scope :last_action_between, lambda {|start_date, end_date|
    where('last_action_datetime >= ? AND last_action_datetime <= ?',
          start_date, end_date)}
  scope :last_action_between_by_board, lambda {|start_date, end_date, board_id|
    where('last_action_datetime >= ? AND last_action_datetime <= ? AND trello_board_id = ?',
          start_date, end_date, board_id)}
  scope :last_action_between_by_board_and_type, lambda {|start_date, end_date, board_id, type|
    where('last_action_datetime >= ? AND last_action_datetime <= ? AND trello_board_id = ? AND card_type = ?',
          start_date, end_date, board_id, type)}
end
