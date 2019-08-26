class ToyController < ApplicationController
  def index
    @board = Trello::AxolotlClient.new.board
    @actions = Trello::AxolotlClient.new.actions
  end
end
