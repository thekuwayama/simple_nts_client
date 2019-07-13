# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Ntske
    class Client
      DEFAULT_HOSTNAME = 'time.cloudflare.com'
      private_constant :DEFAULT_HOSTNAME

      DEFAULT_PORT = 1234
      private_constant :DEFAULT_PORT

      ALPN = 'ntske/1'
      private_constant :ALPN

      KE_LABEL = 'EXPORTER-network-time-security/1'
      private_constant :KE_LABEL

      def initialize(hostname: DEFAULT_HOSTNAME, port: DEFAULT_PORT)
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
      def key_establish
        socket = TCPSocket.new(@hostname, @port)
        client = TTTLS13::Client.new(socket, @hostname, alpn: [ALPN])
        client.connect
        req = [
          NtsNextProtocolNegotiation.new,
          AeadAlgorithmNegotiation.new([AeadAlgorithm::AEAD_AES_SIV_CMAC_256]),
          EndOfMessage.new
        ]
        client.write(req.map(&:serialize))
        res = Nts::Ntske.response_deserialize(client.read)

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

        # C2S, S2C key
        alg = res.find { |m| m.is_a?(AeadAlgorithmNegotiation) }&.algorithms
                &.first
        raise Exception if alg.nil?

        key_len = 32 # only support AEAD_AES_SIV_CMAC_256
        # AEAD Algorithm | NTPv4 context | C2S   / S2C
        # [refer IANA]   | 00 00         | 00 00 / 00 01
        #
        # https://www.iana.org/assignments/aead-parameters/aead-parameters.xhtml#aead-parameters-2
        c2s_key = client.exporter(KE_LABEL, alg + "\x00\x00\x00\x00", key_len)
        s2c_key = client.exporter(KE_LABEL, alg + "\x00\x00\x00\x01", key_len)

        # End of Message
        raise Exception unless res.last&.is_a?(EndOfMessage) &&
                               res.count { |m| m.is_a?(EndOfMessage) } == 1

        [server, port, cookies, c2s_key, s2c_key]
      end
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/CyclomaticComplexity
    end
  end
end
