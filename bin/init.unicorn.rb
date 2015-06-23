#!/usr/bin/env /home/cm/.rbenv/shims/ruby
require "tmpdir"

APP_NAME = "bon"
APP_PATH = "/opt/www/bon/current/"
# APP_PATH = File.expand_path("../../", __FILE__)
UNICORN_RAILS = "unicorn"
UNICORN_CONF = "#{APP_PATH}/config/unicorn.rb"
TMP_DIR = Dir.tmpdir
PID_FILE = "#{TMP_DIR}/.#{APP_NAME}.unicorn.pid"

class Runner
  class << self

    def start
      Dir.chdir "#{APP_PATH}"
      system "#{UNICORN_RAILS} -D -E production -c #{UNICORN_CONF}"
    end

    def reload
      old_pid = pid
      system "kill -s USR2 #{old_pid}"
      print "..wait"
      sleep 2
      if old_pid != pid
        system "kill -s WINCH #{old_pid}"
        system "kill -s QUIT #{old_pid}"
        puts ".. Done."
      else
        puts "!!! Exception raised."
        puts "Please stop and start unicorn process manually."
      end
    end

    def restart
      stop rescue nil
      start
    end

    def stop
      graceful_stop
    end
    def graceful_stop
      system "kill -s QUIT #{pid}"
    end

    def force_stop
      system "kill -s KILL #{pid}"
    end

    def pid
      File.read(PID_FILE).chop
    end

    def status
      begin
        system "ps -o user,pid,ppid,command ax | grep #{pid}"
      rescue
        puts "!!! Is unicorn running?"
      end
    end

  end
end

case ARGV[0]
when "start"
  Runner.start
when "reload"
  Runner.reload
when "restart"
  Runner.restart
when "stop"
  Runner.stop
when "status"
  Runner.status
when "pid"
  Runner.pid
else
  STDERR.puts "Usage: init.unicorn.rb [start|reload|restart|stop|status|pid]"
  exit(1)
end
