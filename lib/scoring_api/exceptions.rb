# frozen_string_literal: true

module ScoringAPI
  class Exceptions
    class Base < RuntimeError
      attr_writer :message
      attr_reader :original_exception

      def initialize(message: nil, original_exception: nil)
        super(nil)
        self.message = message
        @original_exception = original_exception
      end

      def to_s
        "#{self.class}: #{@message || default_message}"
      end

      def default_message
        original_exception&.to_s
      end
    end

    class Timeout < Base
      def default_message
        'Connection Timeout'
      end
    end

    class ConnectionFailed < Base
      def default_message
        'ConnectionFailed'
      end
    end
  end
end
