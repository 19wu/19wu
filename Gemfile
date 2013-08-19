# -*- coding: utf-8 -*-
#
# Some gems cannot/should not be installed on heroku and/or travis, but
# `bundle --without` cannot be used. Put these gems into group :development
# in such situations
# should work until heroku changes the HOME directory location
is_heroku = ['/app/','/app'].include?(ENV['HOME']) # ENV['HOME'] = '/app' in rails console or rake
sqlite3_group = is_heroku ? :development : :sqlite3
mysql2_group = is_heroku ? :development : :mysql2

# Uncomment following lines to deploy 19wu to heroku
# https://devcenter.heroku.com/articles/rails4
# ruby '2.0.0'
# gem 'rails_12factor', group: :production

if ENV['TRAVIS']
  source 'https://rubygems.org'
else
  source 'http://ruby.taobao.org'
end

# if not encoding, `bundle install` command would be error. (Invalid byte sequence in GBK)
# see http://bit.ly/12VbO9n
if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

gem 'rails', '~> 4.0.0'
gem 'slim-rails', '~> 1.1.1'
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
gem 'china_city'
gem 'alipay', github: 'chloerei/alipay'
gem 'priceable', github: 'saberma/priceable' # fixed: migration break.
gem 'jbuilder'
gem 'state_machine'
gem 'state_machine-audit_trail'

group :pg do
  gem 'pg', :platform => [:ruby, :mswin, :mingw]
  gem 'activerecord-jdbcpostgresql-adapter', :platform => [:jruby]
end

group sqlite3_group do
  gem 'sqlite3'
end

group mysql2_group do
  gem 'mysql2', '0.3.11'
end

gem 'devise', '~> 3.0.1'
gem 'devise_invitable', github: 'scambra/devise_invitable'
gem 'settingslogic'
gem "delayed_job", "~> 4.0.0.beta2"
gem 'delayed_job_active_record', '~> 4.0.0.beta3'
gem 'daemons'
gem 'carrierwave'
gem 'friendly_id', github: 'norman/friendly_id', branch: 'master'
gem 'mini_magick', '3.5.0'
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
  gem 'guard-delayed', github: 'jasl/guard-delayed'
  gem 'guard-rails'
  gem 'guard-zeus'

  # Export state_machine transition diagram
  gem 'ruby-graphviz', :require => 'graphviz'
end

group :development, :test do
  gem 'rspec-rails'
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
  gem 'database_cleaner', '1.0.1'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'simplecov', :require => false
  gem 'coveralls', require: false
end

# group :assets do
gem 'sass-rails',     '~> 4.0.0'
gem 'coffee-rails',   '~> 4.0.0'
gem 'bootstrap-sass', '~> 2.3.2.0'
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
