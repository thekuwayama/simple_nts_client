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

module Nts
  module Ntske
    module_function

    # @param s [String]
    #
    # @return [Array of Nts::Ntske::$Object]
    # rubocop: disable Metrics/AbcSize
    # rubocop: disable Metrics/CyclomaticComplexity
    def response_deserialize(s)
      res = []
      i = 0

      while i < s.length
        c = !(s[i].unpack1('c') | 32768).zero?
        type = s.slice(i, 2).unpack1('n') & 32767
        body_len = s.slice(i + 2, 2).unpack1('n')
        sb = s.slice(i + 4, body_len)
        case type
        when 0
          # TODO: check C
          res << EndOfMessage.deserialize(sb)
        when 1
          res << NtsNextProtocolNegotiation.deserialize(sb)
        when 4
          res << AeadAlgorithmNegotiation.deserialize(sb)
        when 5
          res << Cookie.deserialize(sb)
        when 6
          res << Ntsv4ServerNegotiation.deserialize(sb)
        when 7
          res << Ntsv4PortNegotiation.deserialize(sb)
        else
          raise Exception if c
        end
        i += 4 + body_len
      end

      res
    end
    # rubocop: enable Metrics/AbcSize
    # rubocop: enable Metrics/CyclomaticComplexity
  end
end
