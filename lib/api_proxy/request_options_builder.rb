# frozen_string_literal: true

require 'api_signature'

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
      { headers: headers, format: :json }
    end

    def url
      URI::Generic.build(scheme: url_scheme, host: api_host, port: api_port, path: path)
    end

    def request_method
      env['REQUEST_METHOD'].to_s.downcase
    end

    private

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
      request_path = env['REQUEST_PATH'].gsub(request_starts_with, '')

      File.join(api_prefix, request_path)
    end
  end
end
