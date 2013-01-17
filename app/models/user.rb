class User < ActiveRecord::Base
  has_one :profile
  extend FriendlyId

  friendly_id :login

  has_many :events
  has_many :photos
  has_many :joined_events, :class_name => "EventParticipant"
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  validates :login, presence: true, uniqueness: { case_sensitive: false }, format: { with: /[a-zA-Z0-9_]+/ }

  #async devise mailing with delayed job
  handle_asynchronously :send_reset_password_instructions
  handle_asynchronously :send_confirmation_instructions
  handle_asynchronously :send_on_create_confirmation_instructions

  def confirm!
    super
    UserMailer.delay.welcome_email(self)
  end

  # Build profile on-the-fly
  def profile
    super || build_profile
  end
end
