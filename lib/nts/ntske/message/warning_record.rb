# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-4.1.4
    class WarningRecord < Record
      attr_reader :warning_code

      # @param warning_code [Integer]
      def initialize(warning_code)
        super(true, RecordType::WARNING)
        @warning_code = warning_code
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske:WarningRecord]
      def self.deserialize(s)
        raise Exception unless s.length == 2

        WarningRecord.new(s.unpack1('n'))
      end

      private

      # @return [String]
      def serialize_body
        [@warning_code].pack('n1')
      end
    end
  end
end
