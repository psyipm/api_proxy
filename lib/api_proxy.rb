# frozen_string_literal: true

require 'api_proxy/version'
require 'active_support/time'
require 'active_support/time_with_zone'
require 'active_support/core_ext/module'

module ApiProxy
  autoload :Config, 'api_proxy/config'
  autoload :Middleware, 'api_proxy/middleware'
  autoload :HeadersFilter, 'api_proxy/headers_filter'
  autoload :SignedRequest, 'api_proxy/signed_request'
  autoload :ResponseBuilder, 'api_proxy/response_builder'

  def self.configuration(namespace)
    @configuration ||= {}
    @configuration[namespace] ||= Config.new
  end

  # @example
  #   ApiProxy.setup(:namespace) do |config|
  #     config.api_host = '192.168.99.100'
  #   end
  #
  def self.setup(namespace = :default)
    yield(configuration(namespace))
  end
end
