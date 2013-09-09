class User < ActiveRecord::Base
  def gravatar_url(options={}) # do not use gravatar.com service in test environment
    ActionController::Base.helpers.asset_path("avatar-default.png")
  end
end
