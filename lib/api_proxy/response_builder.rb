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
        result.body.to_s,
        result.code,
        response_headers(result)
      )
    end

    private

    def request
      @request ||= Rack::Request.new(env)
    end

    def result
      @result ||= ApiProxy::SignedRequest.new(request.request_method, url, options).perform
    end

    def url
      path = request.path.gsub(config.request_starts_with, '')
      File.join(config.api_url.to_s, path)
    end

    def options
      { namespace: namespace, body: filtered_params, headers: request_headers }
    end

    def filtered_params
      params.reject { |key, _value| config.reject_params.include?(key.to_s) }
    end

    def params
      @params ||= (env['action_dispatch.request.request_parameters'].presence || request.params)
    end

    def request_headers
      config.custom_headers.call(env)
    end

    def response_headers(response)
      ApiProxy::HeadersFilter.new(
        response.headers.merge('content-length' => response.body.size),
        @config.allowed_headers
      ).filter
    end
  end
end
