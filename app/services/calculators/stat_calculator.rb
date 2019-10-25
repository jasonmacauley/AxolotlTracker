module Calculators
  class StatCalculator
    def average_time_in_list(list_id)
      lists = ListTime.where(trello_list_id: list_id)

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

    def trailing_average(cards_by_week, board)
      period = trailing_average_period(board)
      calc_trailing_average(cards_by_week.slice(1, period))
    end

    def trailing_average_trend(cards_by_week, board)
      period = trailing_average_period(board)
      trend = { 'cards' => {}, 'points' => {} }
      i = 0
      while cards_by_week.count > i + period
        average = calc_trailing_average(cards_by_week.slice(i, period))
        trend['cards'][cards_by_week[i][0]] = average[0]
        trend['points'][cards_by_week[i][0]] = average[1]
        i += 1
      end
      return trend
    end

    def calc_trailing_average(cards_by_week)
      cards = 0
      points = 0
      cards_by_week.each do |c|
        cards += c[1]
        points += c[2]
      end
      [cards / cards_by_week.count, points / cards_by_week.count]
    end

    private
    def trailing_average_period(board)
      configs = board.config_hash['trailing_average_period']
      configs.count > 0 ? configs[0].to_i : 5
    end
  end
end
