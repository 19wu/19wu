class InvitationsController < Devise::InvitationsController
  skip_before_filter :authenticate_inviter!, only: :create
  skip_before_filter :has_invitations_left?
  before_filter :authenticate_user!, only: :upgrade

  def upgrade
    build_resource
  end

  def create
    user = if current_user
             current_user.skip_invitation = true
             current_user.invite_reason = params[:user][:invite_reason]
             current_user.invite!
             current_user
           else
             User.invite!(resource_params.merge(skip_invitation: true, confirmed_at: Time.now.utc))
           end
    notice = t('devise.invitations.received') unless user.email.blank?
    redirect_to root_url, notice: notice
  end

  def index
    authorize! :invite, User
    @users = User.where("invitation_token is not null").order("invitation_sent_at desc")
  end

  def mail
    authorize! :invite, User
    user = User.find(params[:id])
    user.invite! current_user
    redirect_to invitations_path
  end

  def upgrade_invite
    authorize! :invite, User
    user = User.find(params[:id])
    user.skip_invitation = true
    user.invite! current_user
    user.accept_invitation!
    UserMailer.delay.invited_email(user)
    redirect_to invitations_path
  end
end
