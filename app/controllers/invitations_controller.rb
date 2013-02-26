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
end
