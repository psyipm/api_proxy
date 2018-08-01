# frozen_string_literal: true

module ApiProxy
  class Config
    attr_accessor :api_key, :api_secret, :url_scheme, :api_host, :api_port, :api_prefix, :request_starts_with

    def initialize
      load_defaults
    end

    def load_defaults
      @api_key = 'key'
      @api_secret = 'secret'

      @url_scheme = 'http'
      @api_host = 'localhost'
      @api_port = 3000

      @api_prefix = '/api/v1/'
      @request_starts_with = '/_ts'
    end
  end
end
