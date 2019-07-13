# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Ntske
    class NtsNextProtocolNegotiation < Record
      attr_reader :next_protocol

      def initialize
        super(false, 1)
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
