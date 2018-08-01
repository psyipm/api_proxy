# frozen_string_literal: true

require 'httparty'

module ApiProxy
  class Request
    include ::HTTParty

    attr_reader :builder

    delegate :url, :options, :request_method, to: :builder

    ALLOWED_HEADERS = [
      'content-type',
      'etag',
      'cache-control',
      'content-disposition',
      'content-transfer-encoding'
    ].freeze

    def initialize(request_options_builder)
      @builder = request_options_builder
    end

    def result
      @result ||= perform_request
    end

    def headers
      result.headers.select { |key, _value| ALLOWED_HEADERS.include?(key) }
    end

    private

    def perform_request
      self.class.send(request_method, url, options)
    end
  end
end
