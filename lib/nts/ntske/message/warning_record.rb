# frozen_string_literal: true

module Nts
  module Ntske
    class WarningRecord < Record
      attr_reader :warning_code

      # @param warning_code [Integer]
      def initialize(warning_code)
        super(true, 3)
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
