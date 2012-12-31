namespace :travis do
  task :before_script do
    db = ENV['DATABASE'] || 'pg'
    system("cp -f config/database.yml.example.#{db} config/database.yml")
    system("cp -f config/settings.yml.example config/settings.yml")
    system("bundle exec rake db:drop db:create db:schema:load --trace 2>&1")
  end

  # append 'jasmine:ci' to run js tests
  task :script => [:spec]
end
