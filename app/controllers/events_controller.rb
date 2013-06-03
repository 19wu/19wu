class EventsController < ApplicationController
  include EventHelper
  prepend_before_filter :authenticate_user!, except: [:show,:followers]
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
    event = Event.find(params[:id])
    participant = event.participants.find_by_user_id(current_user.id)
    respond_to do |format|
      if participant.nil?
        format.html { redirect_to event_path(event), alert: I18n.t('flash.participants.checked_in_need_join_first') }
        format.json { render json: {"message_type" => "alert", "message_body" => I18n.t('flash.participants.checked_in_need_join_first'), "keep" => false} }
      elsif participant.joined
        format.html { redirect_to event_path(event), alert: I18n.t('flash.participants.checked_in_more_than_1_time') }
        format.json { render json: {"message_type" => "alert", "message_body" => I18n.t('flash.participants.checked_in_more_than_1_time'), "keep" => false} }
      else
        if params[:checkin_code] == event.checkin_code
          participant.joined = true
          participant.save
          format.html { redirect_to event_path(event), notice: I18n.t('flash.participants.checked_in_welcome') }
          format.json { render json: {"message_type" => "notice", "message_body" => I18n.t('flash.participants.checked_in_welcome'), "keep" => false} }
        else
          format.html { redirect_to event_path(event), alert: I18n.t('flash.participants.checked_in_wrong_checkin_code') }
          format.json { render json: {"message_type" => "alert", "message_body" => I18n.t('flash.participants.checked_in_wrong_checkin_code'), "keep" => true} }
        end
      end
    end
  end
end
