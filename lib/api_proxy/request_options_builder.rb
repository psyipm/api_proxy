# frozen_string_literal: true

require 'api_signature'

module ApiProxy
  class RequestOptionsBuilder
    attr_reader :env

    delegate :api_key,
             :api_secret,
             :api_host,
             :api_port,
             :api_prefix,
             :url_scheme,
             :request_starts_with, to: :ApiProxy

    def initialize(env)
      @env = env
    end

    def options
      { headers: signature_builder.headers, format: :json }
    end

    def url
      URI::Generic.build(scheme: url_scheme, host: api_host, port: api_port, path: path)
    end

    def request_method
      env['REQUEST_METHOD'].to_s.downcase
    end

    private

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
