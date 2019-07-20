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

      # @return [Time]
      # rubocop: disable Metrics/AbcSize
      # rubocop: disable Metrics/MethodLength
      def what_time
        sock = UDPSocket.new
        localtime = Time.now
        origin_timestamp = t2timestamp(localtime)

        # make NTS-protected NTP packet
        ntp_header = sntp_request_header(origin_timestamp)
        unique_identifier = Extension::UniqueIdentifier.new
        extensions = [
          unique_identifier,
          Extension::NtsCookie.new(@cookie)
        ]
        nonce = OpenSSL::Random.random_bytes(16)
        cipher = Miscreant::AEAD.new('AES-CMAC-SIV', @c2s_key)
        plaintext = extensions.map(&:serialize).join
        ad = ntp_header + plaintext
        ciphertext = cipher.seal(plaintext, nonce: nonce, ad: ad)
        extensions << Extension::NtsAuthenticator.new(nonce, ciphertext)

        # send NTS-protected NTP packet
        req = Sntp::Message.new(ntp_header, extensions)
        sock.send(req.serialize, 0, @hostname, @port)

        # recv NTS-protected NTP packet
        s = nil
        destination_timestamp = nil
        read, = IO.select([sock], nil, nil, 1)
        if read.nil?
          warn 'Timeout: receiving for NTP packet'
          exit 1
        else
          s, = sock.recvfrom(65536)
          destination_timestamp = Time.now
        end
        res = Sntp::Message.deserialize(s)

        # validate response timestamp
        if res.origin_timestamp != origin_timestamp
          warn 'NTP Response Origin Timestamp != NTP Request Transmit Timestamp'
          exit 1
        end

        # validate Unique Identifier
        if res.unique_identifier.id != unique_identifier.id
          warn 'NTP Response Unique Identifier != NTP Request Unique Identifier'
          exit 1
        end

        # validate NTS Authenticator and Encrypted Extension Fields
        decipher = Miscreant::AEAD.new('AES-CMAC-SIV', @s2c_key)
        ciphertext = res.nts_authenticator.ciphertext
        nonce = res.nts_authenticator.nonce
        ad = res.ntp_header + res.extensions.reject { |ex|
          ex.is_a?(Extension::NtsAuthenticator)
        }.map(&:serialize).join
        plaintext = decipher.open(ciphertext, nonce: nonce, ad: ad)
        Message.extensions_deserialize(plaintext)
        # not handle decrypt any NTP Extensions

        # calculate system clock offset
        offset = offset(
          localtime,
          timestamp2t(res.receive_timestamp),
          timestamp2t(res.transmit_timestamp),
          destination_timestamp
        )
        destination_timestamp + offset
      end
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/MethodLength

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

      TIMESTAMP_BASE_DATE = Time.parse('1900-01-01 00:00:00+00:00').to_i
      private_constant :TIMESTAMP_BASE_DATE

      # https://tools.ietf.org/html/rfc5905#section-6
      #
      # @param t [Time]
      #
      # @return [String] NTP Timestamp Format(8 bytes)
      def t2timestamp(t)
        # In order to  minimize bias and help make timestamps unpredictable to
        # an intruder, Fraction should be set to an unbiased random bit string.
        [t.to_i - TIMESTAMP_BASE_DATE].pack('N') \
        + OpenSSL::Random.random_bytes(4)
      end

      # @param s [String] NTP Timestamp Format(8 bytes)
      #
      # @return [Time]
      def timestamp2t(s)
        Time.at(s[0...4].unpack1('N') + TIMESTAMP_BASE_DATE \
                + s[4..].unpack1('N') / (2.0**32))
      end

      # @param t1 [Time]
      # @param t2 [Time]
      # @param t3 [Time]
      # @param t4 [Time]
      #
      # @return [Float]
      def offset(t1, t2, t3, t4)
        # Timestamp Name          ID   When Generated
        # ------------------------------------------------------------
        # Originate Timestamp     T1   time request sent by client
        # Receive Timestamp       T2   time request received by server
        # Transmit Timestamp      T3   time reply sent by server
        # Destination Timestamp   T4   time reply received by client
        #
        # The roundtrip delay d and system clock offset t are defined as:
        #
        # d = (T4 - T1) - (T3 - T2)     t = ((T2 - T1) + (T3 - T4)) / 2.
        # https://tools.ietf.org/html/rfc4330#section-5
        ((t2 - t1) + (t3 - t4)) / 2
      end
    end
  end
end
