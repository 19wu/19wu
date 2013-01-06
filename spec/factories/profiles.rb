# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    trait :with_user do
      user
    end

    trait :autofill do
      name { user.try(:login).try(:capitalize) }
      phone ['1234567', '7654321'].sample
      website ['http://19wu.org', 'http://19wu.com'].sample
      bio '**Launch your Event today**'
    end
  end
end
