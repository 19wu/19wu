# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :fallback_url do
    origin "ruby-conf-china"
    change_to "rubyconfchina"
  end
end
