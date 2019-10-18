class TrelloCard < ApplicationRecord
  has_many :trello_actions
  has_many :trello_list_changes
  has_and_belongs_to_many :trello_labels
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

  def list_changes
    return @list_changes unless @list_changes.nil?
    @list_changes = []
    return @list_changes unless self.trello_list_changes
    changes_by_date = {}
    self.trello_list_changes.each do |change|
      changes_by_date[change.datetime] = change
    end
    dates = changes_by_date.keys.sort
    puts 'Dates => ' + dates.to_s

    previous_date = self.trello_create_date.nil? ? dates[0] : self.trello_create_date
    dates.each do |date|
      puts "Date " + date.to_s + ' - ' + previous_date.to_s
      changes_by_date[date].time_in_list = date.to_time - previous_date.to_time
      previous_date = date
      @list_changes.push(changes_by_date[date])
    end
    return @list_changes
  end
end
