# frozen_string_literal: true

module ApiProxy
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless env['REQUEST_PATH'].start_with?(ApiProxy.request_starts_with)

      builder = RequestOptionsBuilder.new(env)
      request = ApiProxy::Request.new(builder)

      response = request.result

      Rack::Response.new(response, response.code, request.headers)
    end
  end
end
