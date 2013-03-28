# Allow write specs using coffee
Rails.application.assets.append_path File.expand_path('../..', __FILE__)
ENV["JASMINE_BROWSER"] ||= 'chrome'
