FactoryGirl.define do
  sample_login = ['jack', 'lucy', 'dave', 'lily', 'john', 'beth'].sample
  sequence(:login) { |n| "#{sample_login}#{n}" }
  sequence(:email) { |n| "#{sample_login}#{n}@19wu.org".downcase }

  factory :user do
    login '19wu'
    email '19wu@19wu.org'
    password 'D8&m3n$Z'
    password_confirmation 'D8&m3n$Z'
  end

  factory :random_user, parent: :user do
    login
    email
    password ['DJX5nvyX', 'GG83Sr4{', '_pW.2P*8', 'MH^IN3B_'].sample
    password_confirmation { password }
  end
end