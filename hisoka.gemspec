# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hisoka/version'

Gem::Specification.new do |spec|
  spec.name          = "hisoka"
  spec.version       = Hisoka::VERSION
  spec.authors       = ["Mark Burns"]
  spec.email         = ["markthedeveloper@gmail.com"]
  spec.summary       = %q{Simple spies for development}
  spec.description   = %q{Find out what objects in your app are doing}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  if RUBY_VERSION == "1.8.7"
    spec.add_dependency "activesupport", "~> 2.0.2"
    spec.add_development_dependency "ruby-debug"
  else
    spec.add_dependency "activesupport", ">= 2.0.2"
    spec.add_development_dependency "debugger"
  end

  spec.add_development_dependency "json"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
