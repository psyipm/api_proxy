# frozen_string_literal: true

module ApiProxy
  class Client
    def initialize(options = {})
      @options = { namespace: :default }.merge(options)
    end

    [:get, :post, :patch, :put, :delete].each do |type|
      define_method type do |path, options = {}|
        perform_request(type, path, options)
      end
    end

    private

    def perform_request(type, path, options)
      options = @options.merge(options)

      config = ApiProxy.configuration(options[:namespace])
      url = File.join(config.api_url, path)

      ApiProxy::SignedRequest.new(type, url, options).perform
    end
  end
end
