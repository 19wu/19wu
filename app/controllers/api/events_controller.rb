module Api
  class EventsController < ApplicationController
    def participants
      @event = Event.find(params[:id])
      @users = @event.participated_users.recent(10)
    end
  end
end
