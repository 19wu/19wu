# encoding: utf-8
# 初始化开发环境，要支持多次运行
# rake setup
desc "Setup your 19wu development enviroment."
task :setup do
  unless Rails.env == 'production' # 防止生产环境下执行
    puts "1. Copy config file..."
    %w(database settings).each do |name|
      file = "config/#{name}.yml"
      path = Rails.root.join(file)
      unless File.exists?(path)
        source_path = Rails.root.join("#{file}.example")
        puts "copying :#{source_path} => #{path}"
        FileUtils.cp source_path, path
      end
    end

    puts "\n2. Create database and table..."
    Rake::Task['db:setup'].invoke # 会调用db:schema:load(而非db:migrate),db:seed

    puts "\n3. Create test table..."
    %w(db:abort_if_pending_migrations environment db:load_config db:schema:load).each do |name|
      Rake::Task[name].reenable # Rake 很多命令只能运行一次，之后相同的命令会被忽略。db:setup 运行后，中间命令得重新 enable
    end
    Rake::Task['db:test:prepare'].invoke

    puts "\n4. Done! You can run 'rails server' now."
    puts "\nPlease contact us if you have any problems. Thanks.\n"
  end
end
