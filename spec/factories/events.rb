# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "19wu development meeting"
    start_time "2012-12-31 08:00:51"
    end_time "2012-12-31 09:00:51"
    location "Tianjin, China"
    content "Contents here"
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
