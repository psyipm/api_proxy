# frozen_string_literal: true

module ApiProxy
  class Middleware
    def initialize(app, namespace = :default)
      @app = app
      @namespace = namespace
    end

    def call(env)
      builder = ApiProxy::ResponseBuilder.new(env, @namespace)

      return @app.call(env) unless builder.allow_request?

      builder.response.finish
    end
  end
end
