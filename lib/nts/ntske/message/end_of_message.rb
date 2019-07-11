# frozen_string_literal: true

module Nts
  module Ntske
    class EndOfMessage < Record
      def initialize
        super(true, 0)
      end

      def self.deserialize(s)
        raise Exception unless s.empty?

        EndOfMessage.new
      end

      private

      # @return [String]
      def serialize_body
        ''
      end
    end
  end
end
