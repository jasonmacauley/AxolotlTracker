module Calculators
  class Burndown
    def build_burndown_data(configs)
      cards = get_matching_cards_by_date(configs)
      #binding.pry
      keys = cards['created'].keys
      return {} if keys.count == 0
      sorted = keys.sort
      data = {}
      add_data = {}
      subtract_data = {}
      points_data = {}
      points_add = {}
      points_subtract = {}
      days = []
      working_day = sorted[0]

      while working_day < Date.tomorrow
        if data[working_day - 1.day].nil?
          if cards['created'][working_day].nil?
            data[working_day] = 0
            add_data[working_day] = 0
            points_data[working_day] = 0
            points_add[working_day] = 0
          else
            data[working_day] = cards['created'][working_day].count
            points_data[working_day] = count_points(cards['created'][working_day])
            add_data[working_day] = cards['created'][working_day].count
            points_add[working_day] = count_points(cards['created'][working_day])
          end
          data[working_day] -= cards['done'][working_day].count unless cards['done'][working_day].nil?
          points_data[working_day] -= count_points(cards['done'][working_day]) unless cards['done'][working_day].nil?
          cards['done'][working_day].nil? ? subtract_data[working_day] = 0 : subtract_data[working_day] = cards['done'][working_day].count
          cards['done'][working_day].nil? ? points_subtract[working_day] = 0 : points_subtract[working_day] = count_points(cards['done'][working_day])
        else
          if cards['created'][working_day].nil?
            data[working_day] = data[working_day - 1.day]
            add_data[working_day] = add_data[working_day - 1.day]
            points_data[working_day] = points_data[working_day - 1.day]
            points_add[working_day] = points_add[working_day - 1.day]
          else
            data[working_day] = data[working_day - 1.day] + cards['created'][working_day].count
            add_data[working_day] = add_data[working_day - 1.day] + cards['created'][working_day].count
            points_data[working_day] = points_data[working_day - 1.day] + count_points(cards['created'][working_day])
            points_add[working_day] = points_add[working_day - 1.day] + count_points(cards['created'][working_day])
          end
          data[working_day] -= cards['done'][working_day].count unless cards['done'][working_day].nil?
          cards['done'][working_day].nil? ?
              subtract_data[working_day] = subtract_data[working_day - 1.day] :
              subtract_data[working_day] = subtract_data[working_day - 1.day] + cards['done'][working_day].count
          points_data[working_day] -= count_points(cards['done'][working_day]) unless cards['done'][working_day].nil?
          cards['done'][working_day].nil? ?
              points_subtract[working_day] = points_subtract[working_day - 1.day] :
              points_subtract[working_day] = points_subtract[working_day - 1.day] + count_points(cards['done'][working_day])

        end
        days.push(working_day)
        break if data[working_day] == 0
        working_day = working_day + 1.day
      end

      last_30 = days.pop(30)
      trimmed = { 'cards' => {'current' => {},
                              'add' => {},
                              'subtract' => {}
                },
                  'points' => {'current' => {},
                               'add' => {},
                               'subtract' => {}
                  }
      }
      last_30.each do |day|
        trimmed['cards']['current'][day] = data[day]
        trimmed['cards']['add'][day] = add_data[day]
        trimmed['cards']['subtract'][day] = subtract_data[day]
        trimmed['points']['current'][day] = points_data[day]
        trimmed['points']['add'][day] = points_add[day]
        trimmed['points']['subtract'][day] = points_subtract[day]
      end

      burndown_data = { 'cards' => [ { name: 'Cards Remaining', data: trimmed['cards']['current'] },
                                     { name: 'Cards Completed', data: trimmed['cards']['subtract'] },
                                     { name: 'Cards Added', data: trimmed['cards']['add'] }],
                        'points' => [ { name: 'Points Remaining', data: trimmed['points']['current'] },
                                      { name: 'Points Completed', data: trimmed['points']['subtract'] },
                                      { name: 'Points Added', data: trimmed['points']['add'] } ]
      }
      return burndown_data
    end

    private

    def count_points(cards)
      points = 0
      return points if cards.nil?

      cards.each do |card|
        card.points.nil? ? points += 0 : points += card.points
      end
      return points
    end

    def get_matching_cards_by_date(configs)
      cards_by_date = { 'done' => {},
                        'created' => {},
                        'count' => 0
      }
      configs['milestone_labels'].each do |label|
        t_label = TrelloLabel.where(trello_id: label)[0]
        cards = t_label.trello_cards
        cards.each do |card|
          cards_by_date['count'] += 1
          if card.state.match?('done')
            cards_by_date['done'][card.last_action_datetime.to_date].nil? ?
                cards_by_date['done'][card.last_action_datetime.to_date] = [card] :
                cards_by_date['done'][card.last_action_datetime.to_date].push(card)
          end
          next if card.trello_create_date.nil? && card.last_action_datetime.nil?
          card.trello_create_date = card.last_action_datetime.to_date if card.trello_create_date.nil?
          cards_by_date['created'][card.trello_create_date].nil? ?
              cards_by_date['created'][card.trello_create_date] = [card] :
              cards_by_date['created'][card.trello_create_date].push(card)
        end
      end
      return cards_by_date
    end
  end
end
