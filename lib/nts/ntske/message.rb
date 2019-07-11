# frozen_string_literal: true

module Nts
  module Ntske
    class Record
      # @param c [Boolean]
      # @param type [Integer] less than 32768(15 bits)
      def initialize(c, type)
        @c = c
        @type = type
      end

      def serialize
        # super class MUST override serialize_body.
        sb = serialize_body
        [(@c ? 32768 : 0) | @type, sb.length].pack('n2') + sb
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/message/*.rb'].each { |f| require f }
