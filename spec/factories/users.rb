FactoryGirl.define do
  sample_login = ['jack', 'lucy', 'dave', 'lily', 'john', 'beth'].sample
  sequence(:login) { |n| "#{sample_login}#{n}" }
  sequence(:email) { |n| "#{sample_login}#{n}@19wu.org".downcase }
  sequence(:phone) { |n| "1392845288#{n}"}

  factory :user do
    login
    email
    phone
    password ['DJX5nvyX', 'GG83Sr4{', '_pW.2P*8', 'MH^IN3B_'].sample

    trait :confirmed do
      confirmed_at '2013-01-01'
    end
    trait :admin do
      admin true
    end
    trait :with_profile do
      profile
    end
  end
end
