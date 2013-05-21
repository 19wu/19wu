class GroupController < ApplicationController
  def event
    group = Group.find_by_slug(params[:slug])
    @event = group.events.latest.first
    render 'events/show'
  end

  def followers
    group = Group.find_by_slug(params[:slug])
    @event = group.events.latest.first
    render 'events/followers'
  end
end
