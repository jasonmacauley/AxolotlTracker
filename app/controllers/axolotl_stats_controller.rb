class AxolotlStatsController < ApplicationController
  include AxolotlStatsHelper
  def index
    @cards = TrelloCard.all
    @lists = calc_average_time_in_lists(@cards)
    #binding.pry

    five_days_cards = TrelloCard.last_action_between(7.days.ago, Time.now)

    @recent_lists = calc_average_time_in_lists(five_days_cards)

    prior_week = TrelloCard.last_action_between(14.days.ago, 7.days.ago)
    @p_week = calc_average_time_in_lists(prior_week)
  end

  def show
  end
end
