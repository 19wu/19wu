class CollaboratorsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_group!
  set_tab :collaborators

  def index
    @collaborators = @group.collaborators.map do |collaborator|
      {id: collaborator.id, login: collaborator.user.login, avatar_url: collaborator.user.gravatar_url(size: 50)}
    end
  end

  def create
    user = User.where(login: params[:login]).first!
    collaborator = @group.collaborators.create user_id: user.id
    render json: {id: collaborator.id, login: user.login, avatar_url: user.gravatar_url(size: 50)}
  end

  def destroy
    collaborator = @group.collaborators.find(params[:id])
    collaborator.destroy
    render nothing: true
  end

  private
  def authorize_group!
    @event = Event.find(params[:event_id])
    @group = @event.group
    authorize! :update, @group
  end
end
