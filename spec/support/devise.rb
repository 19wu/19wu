module DeviseControllerMacros # http://git.io/WHvARA
  extend ActiveSupport::Concern

  def login_user(user = nil)
    user ||= FactoryGirl.create(:user, :confirmed)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  module ClassMethods
    def login_user(&block)
      before(:each) do
        login_user block.try(:call)
      end
    end
  end
end

module DeviseFeatureMacros
  extend ActiveSupport::Concern

  def sign_in(user = nil)
    user ||= FactoryGirl.create(:user, :confirmed)

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button I18n.t('labels.sign_in')
  end

  alias_method :login_user, :sign_in

  module ClassMethods
    def sign_in(&block)
      before(:each) do
        login_user block.try(:call)
      end
    end

    alias_method :login_user, :sign_in
  end
end

RSpec.configure do |config| # http://git.io/WHvARA
  config.include Devise::TestHelpers, :type => :controller
  config.include DeviseFeatureMacros, :type => :feature
  config.include DeviseControllerMacros, :type => :controller
end
