$LOAD_PATH.unshift('lib')
require 'bundler'
require 'lunar_lander'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

Bundler::GemHelper.install_tasks

desc "Run game"
task :run do  
  LunarLander::Game.new.show
end