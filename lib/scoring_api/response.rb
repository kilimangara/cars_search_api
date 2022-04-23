# frozen_string_literal: true

module ScoringAPI
  class Response
    attr_reader :raw_response, :struct_class

    delegate :code,
             to: :raw_response

    def initialize(response, struct_class = OpenStruct)
      @raw_response = response
      @struct_class = struct_class
      Rails.logger.info("[ScoringAPI] Response #{raw_response.body} #{raw_response.code}")
    end

    def body
      return @body if instance_variable_defined?(:@body)

      @body = JSON.parse(raw_response.body)
    rescue JSON::ParserError
      Rails.logger.info("[ScoringAPI] JSON::ParserError #{raw_response.code} body #{raw_response.body}")
      @body = nil
    end

    def struct
      raise RuntimeError('Cant parse JSON Response') if body.blank?

      @struct ||=
        if body.is_a?(Array)
          body.map { |el| struct_class.new(el) }
        else
          struct_class.new(body)
        end
    end
  end
end
