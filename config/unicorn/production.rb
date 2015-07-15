root = "/home/Matthew/apps/PrimeOne/current"
shared_path= "/home/Matthew/apps/PrimeOne/shared"
working_directory root

pid "#{shared_path}/pids/unicorn.pid"

stderr_path "#{shared_path}/logs/unicorn.access.log"
stdout_path "#{shared_path}/logs/unicorn.error.log"

worker_processes Integer(ENV['WEB_CONCURRENCY'])
timeout 60
preload_app true

listen '#{shared_path}/sockets/unicorn.PrimeOne.sock', backlog: 64

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

# Force the bundler gemfile environment variable to
# reference the capistrano "current" symlink
before_exec do |_|
  ENV['BUNDLE_GEMFILE'] = File.join(root, 'Gemfile')
end
