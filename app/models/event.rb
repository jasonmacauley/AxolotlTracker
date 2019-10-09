class Event < ApplicationRecord
  belongs_to :trello_board
  scope :event_between_by_board, lambda {|start_date, end_date, board_id|
    where('event_date >= ? AND event_date <= ? AND trello_board_id = ?',
          start_date, end_date, board_id)}
end
