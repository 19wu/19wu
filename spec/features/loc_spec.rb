require 'spec_helper'

feature "LOC" do
  before do
    stats = `bundle exec rake stats | grep -v specs`
    @total_loc = stats.scan(/Code LOC: (\d+)/).first.first.to_i
    @views_loc = stats.scan(/Views\s*\|\s*\d+\s*\|\s*(\d+)/).first.first.to_i
    @css_loc   = stats.scan(/CSS\s*\|\s*\d+\s*\|\s*(\d+)/).first.first.to_i
  end

  pending "should keep Ruby&JS code less than 2000 line" do
    (@total_loc - @views_loc - @css_loc).should <= 2000
  end
end
