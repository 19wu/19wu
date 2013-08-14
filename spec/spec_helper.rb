# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'coveralls'
Coveralls.wear!('rails')

ENV["RAILS_ENV"] = 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
#require 'rspec/autorun' # http://j.mp/WLeAs3
require 'capybara/email/rspec'

def locate_executable(name)
  found = nil
  (ENV['PATH'] || '').split(File::PATH_SEPARATOR).each do |dir|
    path = File.join(dir, name)
    found = [path, path + '.exe'].find { |p| File.executable?(p) }
    break if found
  end
  found
end

selenium_browser = if ENV['SELENIUM_BROWSER'] == 'phantomjs'
                     :poltergeist
                   elsif ENV['SELENIUM_BROWSER']
                     ENV['SELENIUM_BROWSER'].to_sym
                   elsif locate_executable('phantomjs')
                     :poltergeist
                   else
                     :firefox
                   end

if selenium_browser == :poltergeist
  require 'capybara/poltergeist'
else
  Capybara.register_driver selenium_browser do |app|
    Capybara::Selenium::Driver.new(app, :browser => selenium_browser)
  end
end
Capybara.javascript_driver = selenium_browser

class Capybara::Email::Driver
  def raw
    if email.mime_type == 'multipart/alternative' && email.html_part
      email.html_part.body.encoded
    else
      email.body.encoded
    end
  end
end

Capybara.server do |app, port|
  # if thin is available, start server using thin
  begin
    require 'rack/handler/thin'
    Rack::Handler::Thin.run(app, :Port => port) do |server|
      server.silent = true
    end
  rescue LoadError
    # ignore
  end
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Mix in FactoryGirl methods
  config.include FactoryGirl::Syntax::Methods

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
