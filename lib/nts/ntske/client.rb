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

      def initialize(hostname: DEFAULT_HOSTNAME, port: DEFAULT_PORT)
        @hostname = hostname
        @port = port
      end

      def key_establish
        socket = TCPSocket.new(@hostname, @port)
        client = TTTLS13::Client.new(socket, @hostname, alpn: [ALPN])
        client.connect
        req = [
          NtsNextProtocolNegotiation.new,
          AeadAlgorithmNegotiation.new([AeadAlgorithm::AEAD_AES_128_GCM]),
          EndOfMessage.new
        ]
        client.write(req.map(&:serialize))
        res = client.read
        pp Nts::Ntske.response_deserialize(res)
      end
    end
  end
end
