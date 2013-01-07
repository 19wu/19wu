# encoding: utf-8
# 初始化开发环境，要支持多次运行
# rake setup
desc "Setup your 19wu development enviroment."
task :setup do
  unless Rails.env == 'production' # 防止生产环境下执行
    puts "1. Copy config file..."
    %w(database settings).each do |name|
      des_file = "config/#{name}.yml"
      des_path = Rails.root.join(des_file)
      unless File.exists?(des_path)
        source_file = "#{des_file}.example"
        if name == 'database'
          # 如果想使用 sqlite，之前要运行 bundle install --without pg，这个 without 参数会保留到 .bundle/config 文件
          # 根据 bundle 安装的数据库适配器直接选择相应的配置文件，默认选择 pg
          db_adapter = Bundler.load.specs.to_hash.keys.select{|name| ['pg','sqlite3','mysql2'].include?(name)}.sort_by(&:size).first
          puts "using #{db_adapter} dabase adapter."
          source_file += ".#{db_adapter}"
        end
        source_path = Rails.root.join(source_file)
        puts "copying :#{source_path} => #{des_path}"
        FileUtils.cp source_path, des_path
      end
    end

    puts "\n2. Create database and table..."
    Rake::Task['db:setup'].invoke # 会调用db:schema:load(而非db:migrate),db:seed

    puts "\n3. Create test table..."
    %w(db:abort_if_pending_migrations environment db:load_config db:schema:load).each do |name|
      Rake::Task[name].reenable # Rake 很多命令只能运行一次，之后相同的命令会被忽略。db:setup 运行后，中间命令得重新 enable
    end
    Rake::Task['db:test:prepare'].invoke

    puts "\n4. Done! You can run 'guard' now."

    puts "\n5. Open /delivered_mails in browser if you need to receive e-mail."

    puts "\nPlease contact us if you have any problems. Thanks.\n"
  end
end
