require 'spec_helper'

feature "Landing Page" do
  scenario "works!" do
    visit '/'
    status_code.should == 200
  end
end
