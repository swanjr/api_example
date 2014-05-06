# -*- encoding: utf-8 -*-
require File.expand_path('../lib/getty/instrumentation/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Getty Images"]
  gem.email         = ["AppDev_RailGun@gettyimages.com"]
  gem.description   = %q{Provides an API for logging and instrumentation for unisporkal applications.}
  gem.summary       = gem.description
  gem.homepage      = ""

  gem.files         = Dir['lib/**/*.*'] + Dir['*.gemspec']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "getty-instrumentation"
  gem.require_paths = ["lib"]
  gem.version       = Getty::Instrumentation::VERSION

  gem.add_dependency 'actionpack'
  gem.add_dependency 'rack'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
