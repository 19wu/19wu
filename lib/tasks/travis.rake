namespace :travis do
  def verbose_system(*args)
    puts(args.join(' '))
    system(*args)
  end
  task :before_script do
    db = ENV['DATABASE'] || 'pg'
    verbose_system("cp -f config/database.yml.example.#{db} config/database.yml")
    verbose_system("cp -f config/settings.yml.example config/settings.yml")
    verbose_system("bundle exec rake db:drop db:create db:schema:load --trace 2>&1")
  end

  # append 'jasmine:ci' to run js tests
  task :script => [:spec]
end
