# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-22#section-4.1.2
    class NtsNextProtocolNegotiation < Record
      attr_reader :next_protocol

      def initialize
        super(false, RecordType::NTS_NEXT_PROTOCOL_NEGOTIATION)
        @next_protocol = "\x00\x00" # Protocol ID 0 (NTPv4)
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::NtsNextProtocolNegotiation]
      def self.deserialize(s)
        # only support NTPv4
        raise Exception unless s == "\x00\x00"

        NtsNextProtocolNegotiation.new
      end

      private

      # @return [String]
      def serialize_body
        @next_protocol
      end
    end
  end
end
