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
    # rubocop: disable Metrics/MethodLength
    # rubocop: disable Metrics/PerceivedComplexity
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
          e = 'The Critical Bit contained in End Of Message MUST be set'
          raise e unless c

          res << EndOfMessage.deserialize(sb)
        when 1
          e = 'The Critical Bit contained in NTS Next Protocol Negotiation ' \
              'MUST be set'
          raise e unless c

          res << NtsNextProtocolNegotiation.deserialize(sb)
        when 2
          e = 'The Critical Bit contained in Error MUST be set'
          raise e unless c

          res << ErrorRecord.deserialize(sb)
        when 3
          e = 'The Critical Bit contained in Warning MUST be set'
          raise e unless c

          res << WarningRecord.deserialize(sb)
        when 4
          res << AeadAlgorithmNegotiation.deserialize(sb, c)
        when 5
          res << Cookie.deserialize(sb, c)
        when 6
          res << Ntsv4ServerNegotiation.deserialize(sb, c)
        when 7
          res << Ntsv4PortNegotiation.deserialize(sb, c)
        else
          raise Exception if c
        end
        i += 4 + body_len
      end

      res
    end
    # rubocop: enable Metrics/AbcSize
    # rubocop: enable Metrics/CyclomaticComplexity
    # rubocop: enable Metrics/MethodLength
    # rubocop: enable Metrics/PerceivedComplexity
  end
end
