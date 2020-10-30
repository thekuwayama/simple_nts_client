# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/rfc8915#section-4.1.6
    class Cookie < Record
      attr_reader :cookie

      # @param cookie [String]
      # @param c [Boolean]
      def initialize(cookie, c = false)
        super(c, RecordType::NEW_COOKIE_FOR_NTPV4)

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
