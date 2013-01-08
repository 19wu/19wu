class HomeController < ApplicationController
  def index
    @events = current_user.events.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end
end
