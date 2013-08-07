class EventTicketsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :ticket

  def index
    @tickets = @event.tickets
  end

  def new
    @ticket = @event.tickets.build
  end

  def create
    @ticket = @event.tickets.build(event_ticket_params)
    if @ticket.save
      redirect_to event_tickets_path(@event)
    else
      render :new
    end
  end

  private

  def event_ticket_params
    params.require(:event_ticket).permit :name, :price, :description
  end
end
