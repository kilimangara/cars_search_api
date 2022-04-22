# frozen_string_literal: true

module ScoringApi
  class Response
    attr_reader :raw_response

    delegate :code,
             to: :raw_response

    def initialize(response)
      @raw_response = response
      Rails.logger.info("[ScoringApi] Response #{raw_response.body} #{raw_response.code}")
    end

    def body
      return @body if instance_variable_defined?(:@body)

      hsh = JSON.parse(raw_response.body)
      @body = hsh.deep_symbolize_keys
    rescue JSON::ParserError
      Rails.logger.info("[ScoringApi] JSON::ParserError #{raw_response.code} body #{raw_response.body}")
      @body = nil
    end

    def success?
      code < 300
    end
  end
end
