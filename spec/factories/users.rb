FactoryGirl.define do
  factory :user do
    login 'Sample User'
    email 'user@example.org'
    password 'D8&m3n\Z'
    password_confirmation 'D8&m3n\Z'
  end
end