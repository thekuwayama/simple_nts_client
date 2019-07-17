# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Sntp
    class Client
      # @param hostname [String]
      # @param port [Integer]
      # @param cookie [String]
      # @param c2s_key [String]
      # @param s2c_key [String]
      def initialize(hostname, port, cookie, c2s_key, s2c_key)
        @hostname = hostname
        @port = port
        @cookie = cookie
        @c2s_key = c2s_key
        @s2c_key = s2c_key
      end

      def what_time
        sock = UDPSocket.new

        localtime = t2timestamp(Time.now)
        ntp_header = sntp_request_header(localtime)
        unique_identifier = Extension::UniqueIdentifier.new
        nts_cookie = Extension::NtsCookie.new(@cookie)
        nonce = OpenSSL::Random.random_bytes(16)
        cipher = Miscreant::AEAD.new('AES-CMAC-SIV', @c2s_key)
        plaintext = unique_identifier.serialize + nts_cookie.serialize
        ad = ntp_header + plaintext
        ciphertext = cipher.seal(plaintext, nonce: nonce, ad: ad)
        nts_authenticator = Extension::NtsAuthenticator.new(nonce, ciphertext)
        req = Sntp::Message.new(
          ntp_header,
          unique_identifier,
          nts_cookie,
          nts_authenticator
        )
        sock.send(req.serialize, 0, @hostname, @port)

        res, = sock.recvfrom(65536)
        pp Sntp::Message.deserialize(res)
      end

      private

      # https://tools.ietf.org/html/rfc5905#section-14
      # https://tools.ietf.org/html/rfc4330#section-5
      #
      # @param xmt [String] transmit timestamp(8 bytes)
      #
      # @return [String]
      def sntp_request_header(xmt)
        # LI(0b00) | VN(0b100) | Mode(0b011) | Stratum(0x00)
        # Poll(0x00) | Precision(0x00)
        # Root Delay(0x00000000)
        # Root Dispersion(0x00000000)
        # Reference ID(0x00000000)
        # Reference Timestamp(0x0000000000000000)
        # Origin Timestamp(0x0000000000000000)
        # Receive Timestamp(0x0000000000000000)
        # Transmit Timestamp(xmt)
        ['00' + '100' + '011'].pack('B8') + "\x00" * 39 + xmt
      end

      # https://tools.ietf.org/html/rfc5905#section-6
      #
      # @param t [Time]
      #
      # @return [String]
      def t2timestamp(t)
        [t.to_i - Time.parse('1900-01-01 00:00:00+00:00').to_i].pack('N') \
        + OpenSSL::Random.random_bytes(4)
      end
    end
  end
end
