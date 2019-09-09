class AxolotlStatsController < ApplicationController
  def index
    @lists = {}

    @cards = TrelloCard.all

    @cards.each do |card|
      i = 0
      card.trello_list_changes.each do |change|

        puts change.time_in_list
        if @lists[change.list_after_name].nil?
          @lists[change.list_after_name] = {}
          @lists[change.list_after_name]['total'] = 0
          @lists[change.list_after_name]['count'] = 0
        end
        next if change.time_in_list.nil?

        @lists[change.list_after_name]['total'] += change.time_in_list
        @lists[change.list_after_name]['count'] += 1
        i += 1
      end
    end
  end

  def show
  end
end
