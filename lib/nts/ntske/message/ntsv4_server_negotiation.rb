# frozen_string_literal: true

module Nts
  module Ntske
    class Ntsv4ServerNegotiation < Record
      attr_reader :server

      # @param server [String]
      def initialize(server)
        super(false, 6)
        @server = server
      end

      def self.deserialize(s)
        raise Exception if s.nil? || s.empty?

        Ntsv4ServerNegotiation.new(s)
      end

      private

      # @return [String]
      def serialize_body
        @server
      end
    end
  end
end
