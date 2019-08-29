module Calculators
  class StatCalculator
    def average_time_in_list(list_id)
      lists = ListTime.where(trello_list_id: list_id)
      puts lists.count

      count = 0
      total = 0
      lists.each do |card|
        next if card.enter.nil? || card.exit.nil?

        days_passed = ((card.exit.to_time - card.enter.to_time) / 3_600) / 24

        total += days_passed
        count += 1
      end

      if count.zero?
        0
      else
        total / count
      end
    end
  end
end
