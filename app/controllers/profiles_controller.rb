class ProfilesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_profile
  layout 'settings'

  def show
  end

  def update
    @profile.assign_attributes(profile_params)

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

  def profile_params
    params.require(:profile).permit :bio, :name, :website
  end
end
