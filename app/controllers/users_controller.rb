class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
    @profile = @user.profile
  end

  def cohort
    non_guests = User.where("invitation_accepted_at IS NOT NULL").all
    @period = "weeks"
    activation_conditions = ["user_id IN (?)", non_guests]
    @cohorts = CohortMe.analyze(period: @period,
                                activation_class: Event,
                                activation_conditions: activation_conditions)
  end
end
