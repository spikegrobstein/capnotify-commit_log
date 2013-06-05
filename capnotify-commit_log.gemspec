# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capnotify/commit_log/version'

Gem::Specification.new do |spec|
  spec.name          = "capnotify-commit_log"
  spec.version       = Capnotify::CommitLog::VERSION
  spec.authors       = ["Spike Grobstein"]
  spec.email         = ["me@spike.cx"]
  spec.description   = %q{Add a detailed Git commit log to your Capnotify deloyment notification emails}
  spec.summary       = %q{Git commit log for Capnotify emails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capnotify"
  spec.add_dependency "git", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
