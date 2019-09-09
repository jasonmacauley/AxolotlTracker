class AxolotlStatsController < ApplicationController
  def index
    @lists = {}

    @cards = TrelloCard.all

    @cards.each do |card|
      i = 0
      until card.trello_list_changes[i+1].nil?
        time_in_list = card.trello_list_changes[i].datetime - card.trello_list_changes[i+1].datetime
        puts time_in_list
        if @lists[card.trello_list_changes[i+1].list_after_name].nil?
          @lists[card.trello_list_changes[i+1].list_after_name] = {}
          @lists[card.trello_list_changes[i+1].list_after_name]['total'] = 0
          @lists[card.trello_list_changes[i+1].list_after_name]['count'] = 0
        end
        @lists[card.trello_list_changes[i+1].list_after_name]['total'] += time_in_list
        @lists[card.trello_list_changes[i+1].list_after_name]['count'] += 1
        i += 1
      end
    end
  end

  def show
  end
end
