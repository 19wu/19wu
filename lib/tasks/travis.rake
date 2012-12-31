namespace :travis do
  task :before_script do
    system("cp -f config/database.yml.example.#{DATABASE} config/database.yml")
    system("cp -f config/settings.yml.example config/settings.yml")
    system("bundle exec rake db:drop db:create db:schema:load --trace 2>&1")
  end

  # append 'jasmine:ci' to run js tests
  task :script => [:spec]
end
