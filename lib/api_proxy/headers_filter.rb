# frozen_string_literal: true

module ApiProxy
  class HeadersFilter
    ALLOWED_HEADERS = [
      'content-type',
      'etag',
      'cache-control',
      'content-length',
      'content-disposition',
      'content-transfer-encoding'
    ].freeze

    def initialize(headers)
      @headers = headers
    end

    def filter
      @headers.select { |key, _value| ALLOWED_HEADERS.include?(key) }
              .transform_values { |value| Array(value)[0] }
    end
  end
end
