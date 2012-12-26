require 'spec_helper'

feature "LOC" do
  subject do
    stats = `bundle exec rake stats`
    stats.scan(/Code LOC: (\d+)/).first.first.to_i
  end

  it { should <= 2000 }
end
