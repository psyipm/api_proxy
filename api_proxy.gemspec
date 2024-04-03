# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_proxy/version'

Gem::Specification.new do |spec|
  spec.name          = 'api_proxy'
  spec.version       = ApiProxy::VERSION
  spec.authors       = ['Igor Malinovskiy']
  spec.email         = ['igor.malinovskiy@netfixllc.org']

  spec.summary       = 'Proxy for tickets service'
  spec.homepage      = 'https://github.com/psyipm/api_proxy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'bundler-audit'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock', '~> 3.4', '>= 3.4.2'

  spec.add_dependency 'activesupport', '>= 4.0'
  spec.add_dependency 'api_signature', '~> 0.1.2'
  spec.add_dependency 'httparty', '>= 0.15'
end
