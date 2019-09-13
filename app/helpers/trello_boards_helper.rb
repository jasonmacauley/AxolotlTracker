module TrelloBoardsHelper
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
