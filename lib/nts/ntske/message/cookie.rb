# frozen_string_literal: true

module Nts
  module Ntske
    class Cookie < Record
      attr_reader :cookie

      # @param cookie [String]
      # @param c [Boolean]
      def initialize(cookie, c = false)
        super(c, 5)

        @cookie = cookie
      end

      # @param s [String]
      # @param c [Boolean]
      #
      # @return [Nts::Ntske::Cookie]
      def self.deserialize(s, c)
        Cookie.new(s, c)
      end

      private

      # @return [String]
      def serialize_body
        @cookie
      end
    end
  end
end
