class InvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_inviter!, only: :create
  skip_before_filter :has_invitations_left?

  def create
    user = User.invite!(resource_params) do |u|
      u.skip_invitation = true
    end
    notice = t('devise.invitations.received') unless user.email.blank?
    redirect_to root_url, notice: notice
  end

  def index
    authorize! :invite, User
    @users = User.where("invitation_token is not null")
  end

  def mail
    authorize! :invite, User
    @user = User.find(params[:id])
    @user.invite!(current_user)
    redirect_to invitations_path
  end
end
