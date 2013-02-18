class EventsController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:show]
  load_resource
  authorize_resource :through => :current_user
  skip_authorize_resource :only => :show

  def joined
    @events = current_user.joined_events
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: I18n.t('flash.events.created') }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = current_user.events.find(params[:id])

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

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def join
    event = Event.find(params[:id])
    event.participants.create(:user_id => current_user.id)

    redirect_to event, notice: 'you has joined this event'
  end
end
