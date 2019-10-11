module Calculators
  class TimeInList
    def initialize(board)
      @board = board
    end

    def calc_average_time_in_lists_for_period(start_date, end_date)
      filter = Calculators::LabelFilter.new(@board)
      cards = filter.filter_cards(TrelloCard.last_action_between_by_board(start_date, end_date, @board.id))
      return calc_average_time_in_lists(cards)
    end

    def calc_average_time_in_lists(cards)
      lists = {}
      cards.each do |card|
        card.trello_list_changes.each do |change|
          handle_nil(change, lists)
          lists[change.list_after_name]['count'] += 1

          next if change.time_in_list.nil?

          lists[change.list_after_name]['total'] += time_in_list(change)
        end
      end
      lists.each do |name, list|
        lists[name]['average'] = 0
        next if ! list['count'] || list['count'] == 0
        lists[name]['average'] = (((list['total']/list['count'])/3600)/24).round(2)
      end
      return lists
    end

    def handle_nil(change, lists)
      init_list(change.list_after_name, lists)
    end

    def init_list(name, lists)
      return if lists[name]

      lists[name] = {}
      lists[name]['total'] = 0
      lists[name]['count'] = 0
    end

    def time_in_list(change)
      change.time_in_list
    end
  end
end
