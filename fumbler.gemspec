# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "fumbler/version"

Gem::Specification.new do |s|
  s.name        = "fumbler"
  s.version     = Fumbler::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Anthony Corcutt"]
  s.email       = ["acorcutt@me.com"]
  s.homepage    = "https://github.com/acorcutt/fumbler"
  s.summary     = %q{Tumblr style template engine for ruby}

  s.rubyforge_project = "fumbler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency("temple")
  s.add_dependency("tilt")
  
  s.add_development_dependency("rspec", ["~> 2.4"])
end
