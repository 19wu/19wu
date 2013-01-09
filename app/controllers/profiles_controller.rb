class ProfilesController < ApplicationController
  prepend_before_filter :authenticate_user!
  before_filter :find_profile
  layout 'settings'

  def show
  end

  def update
    @profile.assign_attributes(params[:profile])

    if @profile.save
      redirect_to profile_path, :notice => I18n.t('flash.profiles.updated')
    else
      render :show
    end
  end

  private
  def find_profile
    @profile = current_user.profile
  end
end
