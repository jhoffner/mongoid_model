# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mongoid_model/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["jake hoffner"]
  gem.email         = ["jake.hoffner@gmail.com"]
  gem.description   = %q{Mongoid extensions. Instead of extending the Mongoid document class itself a separate namespace is used.}
  gem.summary       = %q{Mongoid extensions}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mongoid_model"
  gem.require_paths = ["lib"]
  gem.version       = MongoidModel::VERSION

  gem.add_dependency 'activesupport', '~> 3.2'
  gem.add_dependency('mongoid', [">= 3.0.0"])
  gem.add_development_dependency 'rspec', '~> 2.10'
end
