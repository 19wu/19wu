class TopicReplyController < ApplicationController
  before_filter :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @topic = @event.group.topics.find(params[:topic_id])
    @reply = @topic.replies.build topic_reply_params
    @reply.user = current_user
    @reply.save
    redirect_to event_topic_path(@event, @topic)
  end

  private

  def topic_reply_params
    params.require(:group_topic_reply).permit :body
  end
end
