class AutocompleteController < ApplicationController
  before_filter :authenticate_user!
  def users
    @users = User.where("login like ?", "#{params[:q]}%").select('login').limit(20)
    render json: @users.map(&:login)
  end
end
