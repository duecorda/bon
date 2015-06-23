require "tmpdir"

TMP_DIR = Dir.tmpdir
APP_NAME = "bon"
APP_PATH = File.expand_path("../../", __FILE__)

# recommend: numbers of cpu core + 1
worker_processes 3
timeout 240

listen "#{TMP_DIR}/.#{APP_NAME}.unicorn.sock", :backlog => 512
pid "#{TMP_DIR}/.#{APP_NAME}.unicorn.pid"

stderr_path "#{APP_PATH}/log/unicorn.stderr.log"
stdout_path "#{APP_PATH}/log/unicorn.stdout.log"

preload_app false

GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
