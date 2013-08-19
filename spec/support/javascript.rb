module JavascriptFeatureMacros
  extend ActiveSupport::Concern

  def stub_alert
    page.execute_script("window.alert = function(msg) { return true; }")
  end

  def stub_confirm
    page.execute_script("window.confirm = function(msg) { return true; }")
  end
end

RSpec.configure do |config| # http://git.io/WHvARA
  config.include JavascriptFeatureMacros, type: :feature
end
