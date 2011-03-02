begin
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old." +
   "Run `gem install bundler` to upgrade."
end

begin
  Bundler.setup(:default)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'chingu'
require 'lunar_lander/game'
require 'lunar_lander/game_states/play'
require 'lunar_lander/game_states/pause'
require 'lunar_lander/game_states/gameover'
require 'lunar_lander/game_objects/player'