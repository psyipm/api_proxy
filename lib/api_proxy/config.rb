# frozen_string_literal: true

module ApiProxy
  class Config
    attr_accessor :api_key,
                  :api_secret,
                  :api_url,
                  :request_starts_with,
                  :request_allowed,
                  :custom_headers,
                  :reject_params

    def initialize
      load_defaults
    end

    private

    def load_defaults
      @api_key = 'key'
      @api_secret = 'secret'

      @api_url = 'http://localhost:3000/api/v1'

      @request_starts_with = '/_ts'

      @request_allowed = ->(_env) { true }
      @custom_headers = ->(_env) { {} }

      @reject_params = %w[utf8 authenticity_token commit format controller action]
    end
  end
end
