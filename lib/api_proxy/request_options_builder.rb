# frozen_string_literal: true

require 'api_signature'
require 'rack'

module ApiProxy
  class RequestOptionsBuilder
    attr_reader :env, :config

    delegate :api_key,
             :api_secret,
             :api_host,
             :api_port,
             :api_prefix,
             :url_scheme,
             :request_starts_with, to: :config

    def initialize(env, config)
      @env = env
      @config = config
    end

    def options
      { headers: headers, body: body, format: :json }
    end

    def url
      URI::Generic.build(scheme: url_scheme, host: api_host, port: api_port, path: path)
    end

    def request_method
      request.request_method.downcase
    end

    private

    def body
      request.params.reject { |key, _value| config.reject_params.include?(key) }
    end

    def request
      @request ||= Rack::Request.new(env)
    end

    def headers
      custom_headers = config.custom_headers.call(env)

      signature_builder.headers.merge(custom_headers)
    end

    def signature_builder
      @signature_builder ||= ApiSignature::Builder.new(request_params)
    end

    def request_params
      {
        access_key: api_key,
        secret: api_secret,
        request_method: request_method,
        scheme: url_scheme,
        host: api_host,
        port: api_port,
        path: path
      }
    end

    def path
      request_path = request.path.gsub(request_starts_with, '')

      File.join(api_prefix, request_path)
    end
  end
end
