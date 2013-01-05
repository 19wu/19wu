Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f unless f.end_with?('devise.rb') }

RSpec.configure do |config| # http://git.io/WHvARA
  config.include Devise::TestHelpers, :type => :controller
  config.include FeatureMacros, :type => :feature
  config.extend ControllerMacros, :type => :controller
end
