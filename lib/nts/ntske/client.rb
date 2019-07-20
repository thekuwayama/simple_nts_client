# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Ntske
    class Client
      ALPN = 'ntske/1'
      private_constant :ALPN

      KE_LABEL = 'EXPORTER-network-time-security/1'
      private_constant :KE_LABEL

      # @param hostname [String]
      # @param port [Integer]
      def initialize(hostname, port)
        @hostname = hostname
        @port = port
      end

      # @return [String | nil] NTPv4 Server
      # @return [Integer | nil] NTPv4 Port
      # @return [Array of String] Cookies for NTPv4
      # @return [String] C2S key
      # @return [String] S2C key
      # rubocop: disable Metrics/AbcSize
      # rubocop: disable Metrics/CyclomaticComplexity
      # rubocop: disable Metrics/MethodLength
      # rubocop: disable Metrics/PerceivedComplexity
      def key_establish
        sock = TCPSocket.new(@hostname, @port)
        client = TTTLS13::Client.new(sock, @hostname, alpn: [ALPN])
        client.connect
        req = [
          NtsNextProtocolNegotiation.new,
          AeadAlgorithmNegotiation.new([AeadAlgorithm::AEAD_AES_SIV_CMAC_256]),
          EndOfMessage.new
        ]
        client.write(req.map(&:serialize))
        res = nil
        read, = IO.select([sock], nil, nil, 1)
        if read.nil?
          warn 'Timeout: receiving for NTS-KE messages'
          exit 1
        else
          res = Ntske.response_deserialize(client.read)
        end

        # Error
        er = res.find { |m| m.is_a?(ErrorRecord) }
        raise "received Error(#{er.error_code.unpack1('n')})" unless er.nil?

        # Warning
        wr = res.find { |m| m.is_a?(WarningRecord) }
        raise "received Warning(#{wr.warning_code})" unless wr.nil?

        # Next Protocol Negotiation
        npn = res.select { |m| m.is_a?(NtsNextProtocolNegotiation) }
        raise Exception if npn.nil? || npn.length != 1

        # NTPv4 Server
        server = res.find { |m| m.is_a?(Ntsv4ServerNegotiation) }&.server

        # NTPv4 Port
        port = res.find { |m| m.is_a?(Ntsv4PortNegotiation) }&.port

        # Cookies for NTPv4
        cookies = res.select { |m| m.is_a?(Cookie) }&.map(&:cookie)
        raise Exception if cookies.empty?

        # AEAD algorithm => C2S, S2C key
        # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-5.1
        alg = res.find { |m| m.is_a?(AeadAlgorithmNegotiation) }&.algorithms
                &.first
        raise Exception if alg.nil?

        key_len = 32 # only support AEAD_AES_SIV_CMAC_256
        # NTPv4 context | AEAD Algorithm | C2S  / S2C
        # 0x00 0x00     | [refer IANA]   | 0x00 / 0x01
        c2s_key = client.exporter(KE_LABEL, "\x00\x00" + alg + "\x00", key_len)
        s2c_key = client.exporter(KE_LABEL, "\x00\x00" + alg + "\x01", key_len)

        # End of Message
        raise Exception unless res.last&.is_a?(EndOfMessage) &&
                               res.count { |m| m.is_a?(EndOfMessage) } == 1

        [server, port, cookies, c2s_key, s2c_key]
      end
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/CyclomaticComplexity
      # rubocop: enable Metrics/MethodLength
      # rubocop: enable Metrics/PerceivedComplexity
    end
  end
end
