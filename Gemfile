# -*- coding: utf-8 -*-
#
# Some gems cannot/should not be installed on heroku and/or travis, but
# `bundle --without` cannot be used. Put these gems into group :development
# in such situations
is_travis = !!ENV['TRAVIS']
# should work until heroku changes the HOME directory location
is_heroku = ['/app/','/app'].include?(ENV['HOME']) # ENV['HOME'] = '/app' in rails console or rake
therubyracer_group = (is_travis || is_heroku) ? :development : :assets
sqlite3_group = is_heroku ? :development : :sqlite3
mysql2_group = is_heroku ? :development : :mysql2

source 'https://rubygems.org'

gem 'rails', '3.2.10'
gem 'slim-rails'
gem 'simple_form'

group :pg do
  gem 'pg', :platform => [:ruby, :mswin, :mingw]
  gem 'activerecord-jdbcpostgresql-adapter', :platform => [:jruby]
end

group sqlite3_group do
  gem 'sqlite3'
end

group mysql2_group do
  gem 'mysql2'
end

gem 'devise'
gem 'settingslogic'

group :development do
  gem 'quiet_assets'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'jasmine', '1.3.0'
  gem 'factory_girl_rails', '~> 4.0' # generator will use it in development.
  gem 'thin', '~> 1.5.0'
  gem 'pry-rails'
  gem 'guard-livereload'
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
end

group therubyracer_group do
  # Travis 编译coffee-script # 安装编译过程太慢(大概4分钟)
  # Heroku 编译失败
  gem 'libv8', '3.11.8.3', :platforms => :ruby # therubyracer 从 0.11 开始没有依赖 lib8. http://git.io/EtMkCg
  gem 'therubyracer', :platforms => :ruby
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
