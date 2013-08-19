class EventsController < ApplicationController
  include EventHelper
  before_filter :authenticate_user!, except: [:show,:followers]
  load_and_authorize_resource only: [:edit, :update]
  set_tab :edit, only: :edit

  def index
    @events = current_user.events.latest
  end

  def ordered
    @events = current_user.ordered_events.latest
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  def new
    find_source_events
    @event = if params[:from]
               Event.find(params[:from]).dup
             else
               current_user.events.new
             end
  end

  def create
    @event = current_user.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to group_event_path(@event), notice: I18n.t('flash.events.created') }
        format.json { render json: @event, status: :created, location: @event }
      else
        find_source_events
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to edit_event_path(@event), notice: I18n.t('flash.events.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def follow
    group = Event.find(params[:id]).group
    current_user.follow group
    render json: { count: group.followers_count }
  end
  def unfollow
    group = Event.find(params[:id]).group
    current_user.stop_following group
    render json: { count: group.followers_count }
  end

  def followers
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  private
  def event_params
    params.require(:event).permit(
      :content, :location, :location_guide, :start_time, :end_time, :title, :slug,
      compound_start_time_attributes: [:date, :time], compound_end_time_attributes: [:date, :time]
      )
  end
  # TODO: move these to a model using ActiveModel validation

  def find_source_events
    group_ids = (current_user.group_ids + GroupCollaborator.where(user_id: current_user.id).map(&:group_id)).uniq
    @source_events = Event.where(group_id: group_ids).latest.limit(1)
  end
end
