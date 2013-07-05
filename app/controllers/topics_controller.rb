class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :find_resource

  def new
    @topic = @group.topics.build
  end

  def create
    @topic = @group.topics.build params[:group_topic]
    @topic.user = current_user
    if @topic.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
    @topic = @group.topics.find(params[:id])
  end

  private
  def find_resource
    @event = Event.find(params[:event_id])
    @group = @event.group
  end

end
