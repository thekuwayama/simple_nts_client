# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-4.1.1
    class EndOfMessage < Record
      def initialize
        super(true, RecordType::END_OF_MESSAGE)
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::EndOfMessage]
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
