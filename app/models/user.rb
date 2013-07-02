class User < ActiveRecord::Base
  extend FriendlyId
  acts_as_follower
  friendly_id :login
  has_one :profile
  has_many :events
  has_many :groups
  has_many :photos
  has_many :event_participants
  has_many :joined_events, :through => :event_participants, :source => :event
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :phone, :password, :password_confirmation, :remember_me, :skip_invitation, :invite_reason, :confirmed_at
  # attr_accessible :title, :body
  validates :login, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]+\z/, message: I18n.t('errors.messages.invalid_login') }, length: {in: 3..20}
  validate :login_must_uniq, unless: "login.blank?"

  #async devise mailing with delayed job
  handle_asynchronously :send_reset_password_instructions
  handle_asynchronously :send_confirmation_instructions
  handle_asynchronously :send_on_create_confirmation_instructions

  include Gravtastic
  gravtastic :default => 'mm'

  def confirm!
    super
    UserMailer.delay.welcome_email(self)
    self
  end

  # Build profile on-the-fly
  def profile
    super || build_profile
  end

  def send_reset_password_instructions # http://git.io/Y9Q9eQ
    if self.invited_to_sign_up?
      self.errors.add(:email, :wait_for_invite)
    else
      super
    end
  end

  def collaborator?
    GroupCollaborator.exists?(user_id: self.id)
  end

  def owns?(slug)
    group = Group.find_by_slug(slug)
    group.nil? or group.user == self or group.collaborator?(self)
  end

  def email_with_login
    "#{login} <#{email}>"
  end

  private
  def login_must_uniq
    if Group.exists?(:slug => login) || !FancyUrl.valid_for_short_url?(login)
      errors.add(:login, I18n.t('errors.messages.taken'))
    end
  end
end
