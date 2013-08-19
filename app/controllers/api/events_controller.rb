module Api
  class EventsController < ApplicationController
    def participants
      @event = Event.find(params[:id])
      @users = @event.ordered_users.recent(10)
    end
  end
end
