class GroupController < ApplicationController
  def event
    group = Group.find_by_slug(params[:slug])
    @event = group.events.first
    render 'events/show'
  end
end
