class EventSummariesController < ApplicationController
  prepend_before_filter :authenticate_user!
  set_tab :event_summary, only: :new

  def new
    @event = current_user.events.find(params[:event_id])
    @summary = @event.event_summary || @event.build_event_summary
    render :new
  end

  def create
    @event = current_user.events.find(params[:event_id])
    @summary = @event.build_event_summary(params[:event_summary])

    if @summary.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def update
    @event = current_user.events.find(params[:event_id])
    @summary = @event.event_summary

    if @summary.update_attributes(params[:event_summary])
      redirect_to event_path(@event)
    else
      render :new
    end
  end
end