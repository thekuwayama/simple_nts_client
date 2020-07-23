# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-28#section-4.1.3
    module ErrorCode
      UNRECOGNIZED_CRITICAL_RECORD = "\x00\x00"
      BAD_REQUEST                  = "\x00\x01"
      INTERNAL_SERVER_ERROR        = "\x00\x02"
    end

    class ErrorRecord < Record
      attr_reader :error_code

      # @param error_code [Nts::Ntske::ErrorCode constant]
      def initialize(error_code)
        super(true, RecordType::ERROR)
        @error_code = error_code
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::ErrorRecord]
      def self.deserialize(s)
        raise Exception unless s.length == 2

        ErrorRecord.new(s)
      end

      private

      # @return [String]
      def serialize_body
        @error_code
      end
    end
  end
end
