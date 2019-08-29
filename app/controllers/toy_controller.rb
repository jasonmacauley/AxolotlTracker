class ToyController < ApplicationController
  include ToyHelper
  def index
    @board = Trello::AxolotlClient.new.board
    @actions = Trello::AxolotlClient.new.actions
    @lists = Trello::AxolotlClient.new.lists

    @actions.each do |action|
      ActionType::ActionType.new.handle(action)
    end
    @data = data

    @list_hash = {}
    @lists.each do |list|
      @list_hash[list['id']] = {
          'name' => list['name'],
          'average_time' => Calculators::StatCalculator.new.average_time_in_list(list['id'])
      }
    end
  end
end
