class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @board = TrelloBoard.find(params[:trello_board_id])
  end

  def show
    @board = TrelloBoard.find(params[:trello_board_id])
    start_date = Date.parse(params[:start_date])
    @events = Event.event_between_by_board(start_date, start_date + 1.week, @board.id)
  end

  def new
    @event = Event.new
    @board = TrelloBoard.find(params[:trello_board_id])
  end

  def create
    @event = Event.new
    puts 'Params ' + params[:event][:event_date]
    @board = TrelloBoard.find(params[:trello_board_id])
    @event.event_date = params[:event][:event_date]
    @event.description = params[:event][:description]
    @event.save
    @board.events.push(@event)
    redirect_to(view_board_events_path(@board))
  end

  def edit
  end

  def update
  end

  private

  def event_params
    params.require(:event_params).permit(:trello_board_id, :id, :datetime, :description)
  end
end
