# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tickets_proxy/version'

Gem::Specification.new do |spec|
  spec.name          = 'tickets_proxy'
  spec.version       = TicketsProxy::VERSION
  spec.authors       = ['Igor Malinovskiy']
  spec.email         = ['igor.malinovskiy@netfixllc.org']

  spec.summary       = 'Proxy for tickets service'
  spec.homepage      = 'https://github.com/psyipm/tickets_proxy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'guard-rspec', '~> 4.7', '>= 4.7.3'
  spec.add_development_dependency 'overcommit'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'httparty', '~> 0.16.2'
end
