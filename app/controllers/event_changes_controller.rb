class EventChangesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_event!
  set_tab :change
  set_tab :new_change, :sidebar, only: [:new]
  set_tab :changes   , :sidebar, only: [:index]

  def index
    @changes = @event.changes
  end

  def new
    @change = @event.changes.build
    @participants = @event.participated_users.size
    @participants_with_phone = @event.participated_users.with_phone.size
  end

  def create
    @change = @event.changes.build(params[:event_change])
    if @change.save
      redirect_to event_changes_path(@event)
    else
      render :new
    end
  end
end
