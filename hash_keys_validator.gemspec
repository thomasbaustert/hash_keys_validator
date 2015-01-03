lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hash_keys_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "hash_keys_validator"
  spec.version       = HashKeysValidator::VERSION
  spec.authors       = ["Thomas Baustert"]
  spec.email         = ["business@thomasbaustert.de"]
  spec.summary       = %q{Hash keys validator}
  spec.description   = %q{Validates hash keys according to a whitelist}
  spec.homepage      = "https://github.com/thomasbuatsert/hash_keys_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
