# frozen_string_literal: true

require 'api_proxy/version'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'active_support/core_ext/class'

module ApiProxy
  autoload :Middleware, 'api_proxy/middleware'
  autoload :RequestOptionsBuilder, 'api_proxy/request_options_builder'
  autoload :Request, 'api_proxy/request'

  mattr_accessor :api_key
  self.api_key = 'key'

  mattr_accessor :api_secret
  self.api_secret = 'secret'

  mattr_accessor :url_scheme
  self.url_scheme = 'http'

  mattr_accessor :api_host
  self.api_host = 'localhost'

  mattr_accessor :api_port
  self.api_port = 3000

  mattr_accessor :api_prefix
  self.api_prefix = '/api/v1/'

  mattr_accessor :request_starts_with
  self.request_starts_with = '/_ts'

  # @example
  #   ApiProxy.setup do |config|
  #     config.api_host = '192.168.99.100'
  #   end
  #
  def self.setup
    yield self
  end
end
