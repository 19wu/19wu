class EventChangesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :change
  set_tab :new_change, :sidebar, only: [:new]
  set_tab :changes   , :sidebar, only: [:index]

  def index
    @changes = @event.updates
  end

  def new
    @change = @event.updates.build
  end

  def create
    @change = @event.updates.build(event_change_params)
    if @change.save
      redirect_to event_changes_path(@event)
    else
      render :new
    end
  end

  private

  def event_change_params
    params.require(:event_change).permit :content
  end
end
