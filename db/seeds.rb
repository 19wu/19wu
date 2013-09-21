# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

is_heroku = ['/app/','/app'].include?(ENV['HOME']) # ENV['HOME'] = '/app' in rails console or rake
email = Settings.raw_email(Settings.email.from)
emails = [email]
emails << 'demo@19wu.com' if Rails.env.development? || is_heroku
emails.each do |email|
  login = email.sub(/@.*/,'')                      # 'support@19wu.com' => 'support'
  user = User.where(:login => login, :email => email).first_or_create(:password => '666666').confirm!
  user.admin = true
  user.save(validate:false)
end
