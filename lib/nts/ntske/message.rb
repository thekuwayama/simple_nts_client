# frozen_string_literal: true

module Nts
  module Ntske
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-28#section-7.6
    module RecordType
      END_OF_MESSAGE                = 0
      NTS_NEXT_PROTOCOL_NEGOTIATION = 1
      ERROR                         = 2
      WARNING                       = 3
      AEAD_ALGORITHM_NEGOTIATION    = 4
      NEW_COOKIE_FOR_NTPV4          = 5
      NTPV4_SERVER_NEGOTIATION      = 6
      NTPV4_PORT_NEGOTIATION        = 7
    end

    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-28#section-4
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

Dir[File.dirname(__FILE__) + '/message/*.rb'].sort.each { |f| require f }

module Nts
  module Ntske
    module_function

    # @param s [String]
    #
    # @raise [Exception | RuntimeError]
    #
    # @return [Array of Nts::Ntske::$Object]
    # @return [String] surplus binary
    # rubocop: disable Metrics/AbcSize
    # rubocop: disable Metrics/CyclomaticComplexity
    # rubocop: disable Metrics/MethodLength
    # rubocop: disable Metrics/PerceivedComplexity
    def response_deserialize(s)
      res = []
      i = 0
      while i < s.length
        return [res, s[i..]] if i + 4 > s.length

        c = !(s[i].unpack1('c') | 32768).zero?
        type = s.slice(i, 2).unpack1('n') & 32767
        body_len = s.slice(i + 2, 2).unpack1('n')
        return [res, s[i..]] if i + 4 + body_len > s.length

        sb = s.slice(i + 4, body_len)
        case type
        when RecordType::END_OF_MESSAGE
          e = 'The Critical Bit contained in End Of Message MUST be set'
          raise e unless c

          res << EndOfMessage.deserialize(sb)
        when RecordType::NTS_NEXT_PROTOCOL_NEGOTIATION
          e = 'The Critical Bit contained in NTS Next Protocol Negotiation ' \
              'MUST be set'
          raise e unless c

          res << NtsNextProtocolNegotiation.deserialize(sb)
        when RecordType::ERROR
          e = 'The Critical Bit contained in Error MUST be set'
          raise e unless c

          res << ErrorRecord.deserialize(sb)
        when RecordType::WARNING
          e = 'The Critical Bit contained in Warning MUST be set'
          raise e unless c

          res << WarningRecord.deserialize(sb)
        when RecordType::AEAD_ALGORITHM_NEGOTIATION
          res << AeadAlgorithmNegotiation.deserialize(sb, c)
        when RecordType::NEW_COOKIE_FOR_NTPV4
          res << Cookie.deserialize(sb, c)
        when RecordType::NTPV4_SERVER_NEGOTIATION
          res << Ntsv4ServerNegotiation.deserialize(sb, c)
        when RecordType::NTPV4_PORT_NEGOTIATION
          res << Ntsv4PortNegotiation.deserialize(sb, c)
        else
          raise Exception if c
        end
        i += 4 + body_len
      end
      raise Exception unless i == s.length

      [res, '']
    end
    # rubocop: enable Metrics/AbcSize
    # rubocop: enable Metrics/CyclomaticComplexity
    # rubocop: enable Metrics/MethodLength
    # rubocop: enable Metrics/PerceivedComplexity
  end
end
