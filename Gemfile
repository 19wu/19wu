source 'https://rubygems.org'

gem 'rails', '3.2.9'
gem 'slim-rails'
gem 'pg', :platform => [:ruby, :mswin, :mingw]
gem 'activerecord-jdbcpostgresql-adapter', :platform => [:jruby]

gem 'devise'
group :development do
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jasmine', '1.3.0'
  gem 'factory_girl_rails', '~> 4.0' # generator will use it in development.
end

group :test do
  gem 'capybara'
end

group :assets do
  gem 'sass-rails',     '~> 3.2.3'
  gem 'coffee-rails',   '~> 3.2.1'
  gem 'bootstrap-sass', '~> 2.2.2.0'
  gem 'uglifier',       '>= 1.0.3'
  gem 'jquery-rails'

  unless ENV['TRAVIS'] # 编译coffee-script # 安装编译过程太慢(大概4分钟)
    gem 'libv8', '3.11.8.3', :platforms => :ruby # therubyracer 从 0.11 开始没有依赖 lib8. http://git.io/EtMkCg
    gem 'therubyracer', :platforms => :ruby
  end
end



# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
