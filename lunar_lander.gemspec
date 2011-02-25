# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "lunar_lander/version"

Gem::Specification.new do |s|
  s.name        = "lunar_lander"
  s.version     = LunarLander::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lucas Roxo Mundim"]
  s.email       = ["lucas.mundim@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Moon landing simulator}
  s.description = %q{Ruby version of 1979 Atari video game Lunar Lander}

  s.rubyforge_project = "lunar_lander"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
