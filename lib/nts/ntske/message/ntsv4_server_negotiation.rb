# frozen_string_literal: true

module Nts
  module Ntske
    class Ntsv4ServerNegotiation < Record
      attr_reader :server

      # @param server [String]
      # @param c [Boolean]
      def initialize(server, c = false)
        super(c, 6)
        @server = server
      end

      # @param s [String]
      # @param c [Boolean]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::Ntsv4ServerNegotiation]
      def self.deserialize(s, c)
        raise Exception if s.nil? || s.empty?

        Ntsv4ServerNegotiation.new(s, c)
      end

      private

      # @return [String]
      def serialize_body
        @server
      end
    end
  end
end
