class EventSummariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :event_summary, only: :new

  def new
    @summary = @event.event_summary || @event.build_event_summary
    render :new
  end

  def create
    @summary = @event.build_event_summary(event_summary_params)

    if @summary.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def update
    @summary = @event.event_summary

    if @summary.update_attributes(event_summary_params)
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  private

  def event_summary_params
    params.require(:event_summary).permit :content
  end
end
