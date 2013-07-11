class EventSummariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :event_summary, only: :new

  def new
    @summary = @event.event_summary || @event.build_event_summary
    render :new
  end

  def create
    @summary = @event.build_event_summary(params[:event_summary])

    if @summary.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def update
    @summary = @event.event_summary

    if @summary.update_attributes(params[:event_summary])
      redirect_to event_path(@event)
    else
      render :new
    end
  end
end
