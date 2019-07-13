# frozen_string_literal: true

module Nts
  module Ntske
    class Ntsv4PortNegotiation < Record
      attr_reader :port

      # @param port [Integer]
      def initialize(port)
        super(false, 7)
        @port = port
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::Ntsv4PortNegotiation]
      def self.deserialize(s)
        raise Exception unless s.length == 2

        Ntsv4PortNegotiation.new(s.unpack1('n'))
      end

      private

      # @return [String]
      def serialize_body
        [@port].pack('n1')
      end
    end
  end
end
