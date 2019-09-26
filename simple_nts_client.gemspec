# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nts/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_nts_client'
  spec.version       = Nts::VERSION
  spec.authors       = ['thekuwayama']
  spec.email         = ['thekuwayama@gmail.com']
  spec.summary       = 'Simple NTS(Network Time Security) Client'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/thekuwayama/simple_nts_client'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>=2.6.1'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  spec.bindir        = 'exe'
  spec.executables   = ['simple_nts_client']

  spec.add_development_dependency 'bundler'
  spec.add_dependency             'miscreant'
  spec.add_dependency             'tttls1.3', '>= 0.2.7'
end
