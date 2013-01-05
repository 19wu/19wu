require Rails.root.join("spec/support/controller_macros.rb")

RSpec.configure do |config| # http://git.io/WHvARA
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end
