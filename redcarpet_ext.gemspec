# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redcarpet_ext/version'

Gem::Specification.new do |spec|
  spec.name          = "redcarpet_ext"
  spec.version       = RedcarpetExt::VERSION
  spec.authors       = ["Matthias Seelig"]
  spec.email         = ["matthias.seelig@ymail.com"]
  spec.description   = %q{Extending redcarpet Markdown with a couple of needed extensions}
  spec.summary       = %q{Extend Markdown on the red carpet}
  spec.homepage      = "http://github.com/matse/redcarpet_ext"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "actionview"
end
