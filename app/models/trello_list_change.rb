class TrelloListChange < ApplicationRecord
  belongs_to :trello_card

  def seconds_in_list
    return self.time_in_list
  end

  def minutes_in_list
    return self.time_in_list/60
  end

  def hours_in_list
    return self.minutes_in_list/60
  end

  def days_in_list
    return self.hours_in_list/24
  end
end
