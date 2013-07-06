class TopicReplyController < ApplicationController
  before_filter :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @topic = @event.group.topics.find(params[:topic_id])
    @reply = @topic.replies.build params[:group_topic_reply]
    @reply.user = current_user
    @reply.save
    redirect_to event_topic_path(@event, @topic)
  end
end
