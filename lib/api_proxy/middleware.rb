# frozen_string_literal: true

module ApiProxy
  class Middleware
    def initialize(app, namespace = :default)
      @app = app
      @config = ApiProxy.configuration(namespace)
    end

    def call(env)
      return @app.call(env) unless allow_request?(env)

      builder = RequestOptionsBuilder.new(env, @config)
      request = ApiProxy::Request.new(builder)

      response = request.result

      Rack::Response.new(response.to_s, response.code, request.headers)
    end

    def allow_request?(env)
      return false unless env['REQUEST_PATH'].start_with?(@config.request_starts_with)

      @config.request_allowed.call(env)
    end
  end
end
