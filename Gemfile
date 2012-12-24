source 'https://rubygems.org'

gem 'rails', '3.2.9'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg', :platform => [:ruby, :mswin, :mingw]
gem 'activerecord-jdbcpostgresql-adapter', :platform => [:jruby]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  unless ENV['TRAVIS'] # 编译coffee-script # 安装编译过程太慢(大概4分钟)
    gem 'libv8', :platforms => :ruby # therubyracer 从 0.11 开始没有依赖 lib8. http://git.io/EtMkCg
    gem 'therubyracer', :platforms => :ruby
  end

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'jasmine', '1.3.0'
end

group :test do
  gem 'capybara'
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
