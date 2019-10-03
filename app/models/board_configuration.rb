class BoardConfiguration < ApplicationRecord
  belongs_to :trello_board
  scope :config_by_board_type_value, lambda {|board_id, config_type, value|
    where('trello_board_id = ? AND config_type = ? AND value = ?',
          board_id, config_type, value)}
  scope :config_by_board_type, lambda {|board_id, config_type|
    where('trello_board_id = ? AND config_type = ?',
          board_id, config_type)}
end
