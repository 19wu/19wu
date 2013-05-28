class CollaboratorsController < ApplicationController
  prepend_before_filter :authenticate_user!
  before_filter :authenticate_event_creator!
  set_tab :collaborators

  def index
    event = current_user.events.find(params[:event_id])
    @collaborators = event.group.collaborators.map do |collaborator|
      {id: collaborator.id, login: collaborator.user.login, avatar_url: collaborator.user.gravatar_url(size: 50)}
    end
  end

  def create
    user = User.find_by_login(params[:login])
    event = current_user.events.find(params[:event_id])
    collaborator = event.group.collaborators.create user_id: user.id
    render json: {id: collaborator.id, login: user.login, avatar_url: user.gravatar_url(size: 50)}
  end

  def destroy
    event = current_user.events.find(params[:event_id])
    collaborator = event.group.collaborators.find(params[:id])
    collaborator.destroy
    render nothing: true
  end
end
