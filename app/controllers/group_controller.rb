class GroupController < ApplicationController
  def event
    group = Group.where(slug: params[:slug]).first!
    @event = group.events.latest.first
    render 'events/show'
  end

  def followers
    group = Group.where(slug: params[:slug]).first!
    @event = group.events.latest.first
    render 'events/followers'
  end
end
