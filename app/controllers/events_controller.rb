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
    @board = TrelloBoard.find(params[:trello_board_id])
    @event.event_date = params[:event][:event_date]
    @event.description = params[:event][:description]
    @event.save
    @board.events.push(@event)
    @board.save
    redirect_to(trello_board_path(@board))
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.event_date = params[:event][:event_date]
    @event.description = params[:event][:description]
    @event.save
    redirect_to(trello_board_path(TrelloBoard.find(@event.trello_board_id)))
  end

  def destroy
    redirect_to(trello_board_path(@board)) unless @event = Event.find(params[:id])
    @event = Event.find(params[:id])
    @board = TrelloBoard.find(params[:trello_board_id])
    @event.destroy
    redirect_to(trello_board_path(@board))
  end

  private

  def event_params
    params.require(:event_params).permit(:trello_board_id, :id, :datetime, :description)
  end
end
