module Api
  class EventsController < ApplicationController
    def participated_users
      @event = Event.find(params[:id])
      @users = @event.participated_users.recent(10)
    end
  end
end
