# frozen_string_literal: true

module Nts
  module Ntske
    class Cookie < Record
      attr_reader :cookie

      # @param cookie [String]
      def initialize(cookie)
        super(false, 5)

        @cookie = cookie
      end

      # @param s [String]
      #
      # @return [Nts::Ntske::Cookie]
      def self.deserialize(s)
        Cookie.new(s)
      end

      private

      # @return [String]
      def serialize_body
        @cookie
      end
    end
  end
end
