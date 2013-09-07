# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "19wu development meeting"
    start_time 8.day.since
    end_time 9.days.since
    location "Tianjin, China"
    content "Contents here"
    slug "rubyconfchina"
    user

    trait :markdown do
      content <<-MD
# Awesome Event #

-   free wifi
-   free coffee
      MD
      location_guide <<-MD
subway line 2, foo station
      MD
    end
  end
end
