# encoding: utf-8
# 初始化开发环境，要支持多次运行
# rake setup
desc "Setup your 19wu development enviroment."
task :setup do
  unless Rails.env == 'production' # 防止生产环境下执行
    puts "1. Copy config file..."
    %w(database).each do |name|
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

    puts "\n3. Done! You can run 'rails server' now."
    puts "\nPlease contact us if you have any problems. Thanks."
  end
end
