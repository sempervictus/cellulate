# -*- encoding: utf-8 -*-
require File.expand_path('../lib/celluloid/cellulate', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Boris Lukashev"]
  gem.email         = ["blukashev [at] sempervictus.com"]
  gem.description   = "Late Init for Celluloid actors"
  gem.summary       = "Cellulate allows for late initialization of celluloid objects"
  gem.homepage      = "http://github.com/sempervictus/cellulate"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.name          = "cellulate"
  gem.require_paths = ["lib"]
  gem.version       = Celluloid::Cellulate::VERSION

  gem.add_dependency 'celluloid'

end
