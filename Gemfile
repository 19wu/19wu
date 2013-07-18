# -*- coding: utf-8 -*-
#
# Some gems cannot/should not be installed on heroku and/or travis, but
# `bundle --without` cannot be used. Put these gems into group :development
# in such situations
# should work until heroku changes the HOME directory location
is_heroku = ['/app/','/app'].include?(ENV['HOME']) # ENV['HOME'] = '/app' in rails console or rake
sqlite3_group = is_heroku ? :development : :sqlite3
mysql2_group = is_heroku ? :development : :mysql2

if ENV['TRAVIS']
  source 'https://rubygems.org'
else
  source 'http://ruby.taobao.org'
end

gem 'rails', '4.0.0'
gem 'slim-rails', '1.1.1'
gem 'simple_form', '~> 3.0.0.rc'
gem 'html-pipeline'
# html-pipeline depends on escape_utils, lock its version for Windows
gem 'escape_utils', '0.2.4'
gem 'has_html_pipeline'
gem 'kramdown', :platform => [:jruby]
gem 'gravtastic'
gem 'cancan'
gem 'cohort_me'
gem 'acts_as_follower', github: 'flingbob/acts_as_follower'
gem "angularjs-rails"
gem "rabl"
gem 'whenever', :require => false
gem "tabs_on_rails"
gem "china_sms"

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

gem 'devise', '3.0.0.rc'
gem 'devise_invitable', github: 'scambra/devise_invitable', branch: 'rails4'
gem 'settingslogic'
gem "delayed_job", "~> 4.0.0.beta2"
gem 'delayed_job_active_record', '~> 4.0.0.beta3'
gem 'daemons'
gem 'carrierwave'
gem 'friendly_id', github: 'FriendlyId/friendly_id', branch: 'rails4'
gem 'mini_magick'
gem 'rails-timeago'

group :production do
  # Use unicorn as the app server
  gem 'unicorn', :platforms => :ruby
  gem 'exception_notification'
end

group :development do
  gem 'rvm-capistrano'
  gem 'mails_viewer'
  gem 'quiet_assets'
  gem 'guard-delayed'
  gem 'guard-rails'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'jasmine-rails', github: 'searls/jasmine-rails'
  gem 'factory_girl_rails', '~> 4.0' # generator will use it in development.
  gem 'thin', '~> 1.5.0', :platform => [:ruby, :mswin, :mingw] # thin cannot run under jruby
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'guard-livereload'
end

group :test do
  gem 'capybara'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'simplecov', :require => false
  gem 'coveralls', require: false
end

# group :assets do
gem 'sass-rails',     '~> 4.0.0'
gem 'coffee-rails',   '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.2.2.0'
gem 'uglifier',       '>= 1.3.0'
gem 'jquery-rails'
gem 'bootstrap-datepicker-rails'
gem 'jquery-fileupload-rails'
gem 'bootstrap-timepicker-rails-addon'

  # 推荐安装 node.js，而不要 therubyracer
  #gem 'libv8', '3.11.8.3', :platforms => :ruby # therubyracer 从 0.11 开始没有依赖 lib8. http://git.io/EtMkCg
  #gem 'therubyracer', :platforms => :ruby
# end

# fallback
gem 'rails-observers'