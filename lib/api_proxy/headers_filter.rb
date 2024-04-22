# frozen_string_literal: true

module ApiProxy
  class HeadersFilter
    def initialize(headers, allowed_headers)
      @headers = headers
      @allowed_headers = allowed_headers
    end

    def filter
      @headers.select { |key, value| @allowed_headers.include?(key) && value.present? }
              .transform_values { |value| Array(value)[0] }
    end
  end
end
