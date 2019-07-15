# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-4.1.7
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
