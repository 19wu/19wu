class EventsController < ApplicationController
  include EventHelper
  before_filter :authenticate_user!, except: [:show,:followers]
  load_and_authorize_resource only: [:edit, :update]
  set_tab :edit, only: :edit

  def index
    @events = current_user.events.latest
  end

  def joined
    @events = current_user.joined_events.latest
  end

  def show
    @event = Event.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to group_event_path(@event), notice: I18n.t('flash.events.created') }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to edit_event_path(@event), notice: I18n.t('flash.events.updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
    event = Event.find(params[:id])
    event.participants.create(:user_id => current_user.id)
    render json: { count: event.participated_users.size, joined: event.has?(current_user), notice: I18n.t('flash.participants.joined')}
  end

  def quit
    event = Event.find(params[:id])
    event.participated_users.delete(current_user)
    render json: { count: event.participated_users.size, joined: event.has?(current_user), notice: I18n.t('flash.participants.quited')}
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

  def checkin
    @event = Event.find(params[:id])
    participant = @event.participants.find_by_user_id(current_user.id)
    error = validate_checkin(@event, participant)
    json = checkin_response_json(error)

    unless error
      participant.joined = true
      participant.save
    end

    respond_to do |format|
      format.html {
        flash[json['message_type']] = json['message_body']
        redirect_to event_path(@event)
      }
      format.json {
        render :json => json
      }
    end
  end

  private
  # TODO: move these to a model using ActiveModel validation

  # Return symbol representing validation result
  def validate_checkin(event, participant)
    if participant.nil?
      :checkin_need_join_first
    elsif ! event.start_time.today?
      :checkin_in_need_the_same_day_of_event_starttime
    elsif participant.joined
      :checkin_more_than_1_time
    elsif params[:checkin_code] != event.checkin_code
      :checkin_wrong_checkin_code
    end
  end

  def checkin_response_json(error)
    # Only keep the button when user entered wrong code
    keep_button = error == :checkin_wrong_checkin_code
    message_type = error ? :alert : :notice
    message = I18n.t("flash.participants.#{error || 'checkin_welcome'}")

    {
      "message_type" => message_type,
      "message_body" => message,
      "keep" => keep_button
    }
  end
end
