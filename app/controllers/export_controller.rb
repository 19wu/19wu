class ExportController < ApplicationController
  prepend_before_filter :authenticate_user!
  set_tab :export

  def index
    @event = Event.find(params[:event_id])
  end
end
