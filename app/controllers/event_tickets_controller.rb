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

  def edit
    @ticket = @event.tickets.find(params[:id])
  end

  def update
    @ticket = @event.tickets.find(params[:id])
    if @ticket.update_attributes(event_ticket_params)
      redirect_to event_tickets_path(@event), notice: I18n.t('flash.updated')
    else
      render action: "edit"
    end
  end

  def destroy
    @ticket = @event.tickets.find(params[:id])
    @ticket.destroy
    redirect_to event_tickets_path(@event), notice: I18n.t('flash.destroyed')
  end

  private

  def event_ticket_params
    params.require(:event_ticket).permit :name, :price, :require_invoice, :description, :tickets_quantity
  end
end
