# encoding: utf-8
# config/unicorn.rb
# see: http://ariejan.net/2011/09/14/lighting-fast-zero-downtime-deployments-with-git-capistrano-nginx-and-unicorn
# Set environment to development unless something else is specified
application = '19wu'

# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.
worker_processes 4

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
listen "/tmp/#{application}.socket", backlog: 64

# Preload our app for more speed
preload_app true

# nuke workers after 30 seconds instead of 60 seconds (the default)
timeout 30

app_path = "/u/apps/#{application}"
shared_path = "#{app_path}/shared"
current_path = "#{app_path}/current"
pid "#{shared_path}/pids/unicorn.#{application}.pid"

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
working_directory current_path

stderr_path "#{shared_path}/log/unicorn.stderr.log"
stdout_path "#{shared_path}/log/unicorn.stdout.log"

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{shared_path}/pids/unicorn.#{application}.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end

  # if preload_app is true, then you may also want to check and
  # restart any other shared sockets/descriptors such as Memcached,
  # and Redis.  TokyoCabinet file handles are safe to reuse
  # between any number of forked children (assuming your kernel
  # correctly implements pread()/pwrite() system calls)
end

before_exec do |server| # 修正无缝重启unicorn后更新的Gem未生效的问题，原因是config/boot.rb会优先从ENV中获取BUNDLE_GEMFILE，而无缝重启时ENV['BUNDLE_GEMFILE']的值并未被清除，仍指向旧目录的Gemfile
  ENV["BUNDLE_GEMFILE"] = "#{current_path}/Gemfile"
end
