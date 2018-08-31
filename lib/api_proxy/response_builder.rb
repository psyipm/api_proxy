# frozen_string_literal: true

require 'rack'

module ApiProxy
  class ResponseBuilder
    attr_reader :env, :namespace, :config

    def initialize(env, namespace = :default)
      @env = env
      @namespace = namespace
      @config = ApiProxy.configuration(namespace)
    end

    def allow_request?
      return false unless request.path.start_with?(config.request_starts_with)

      config.request_allowed.call(@env)
    end

    def response
      Rack::Response.new(
        result.to_s,
        result.code,
        ApiProxy::HeadersFilter.new(result.headers).filter
      )
    end

    private

    def request
      @request ||= Rack::Request.new(@env)
    end

    def result
      @result ||= ApiProxy::SignedRequest.new(request.request_method, url, options).perform
    end

    def url
      path = request.path.gsub(config.request_starts_with, '')
      File.join(config.api_url.to_s, path)
    end

    def options
      { namespace: namespace, body: filtered_params, headers: headers }
    end

    def filtered_params
      request.params.reject { |key, _value| config.reject_params.include?(key.to_s) }
    end

    def headers
      config.custom_headers.call(env)
    end
  end
end
