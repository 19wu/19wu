class TopicsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :find_resource

  def new
    @topic = @group.topics.build
  end

  def create
    @topic = @group.topics.build group_topic_params
    @topic.user = current_user
    if @topic.save
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  def show
    @topic = @group.topics.find(params[:id])
    @replies = @topic.replies
    @reply = GroupTopicReply.new
  end

  private
  def find_resource
    @event = Event.find(params[:event_id])
    @group = @event.group
  end

  def group_topic_params
    params.require(:group_topic).permit :body, :title
  end
end
