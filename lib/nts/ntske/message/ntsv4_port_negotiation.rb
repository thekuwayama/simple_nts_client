# frozen_string_literal: true

module Nts
  module Ntske
    class Ntsv4PortNegotiation < Record
      attr_reader :port

      # @param port [Integer]
      # @param c [Boolean]
      def initialize(port, c = false)
        super(c, 7)
        @port = port
      end

      # @param s [String]
      # @param c [Boolean]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::Ntsv4PortNegotiation]
      def self.deserialize(s, c)
        raise Exception unless s.length == 2

        Ntsv4PortNegotiation.new(s.unpack1('n'), c)
      end

      private

      # @return [String]
      def serialize_body
        [@port].pack('n1')
      end
    end
  end
end
