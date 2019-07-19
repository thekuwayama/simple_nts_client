# frozen_string_literal: true

require __dir__ + '/extension.rb'

module Nts
  module Sntp
    # https://tools.ietf.org/html/rfc5905#section-7.3
    class Message
      # @param ntp_header [String] 48-octet NTP header(leap ~ xmt)
      # @param unique_identifier [Nts::Sntp::Extension::UniqueIdentifier]
      # @param nts_cookie [Nts::Sntp::Extension::NtsCookie]
      # @param nts_authenticator [Nts::Sntp::Extension::NtsAuthenticator]
      def initialize(ntp_header,
                     unique_identifier,
                     nts_cookie,
                     nts_authenticator)
        @ntp_header = ntp_header
        @unique_identifier = unique_identifier
        @nts_cookie = nts_cookie
        # TODO: nts_cookie_placeholder
        @nts_authenticator = nts_authenticator
      end

      # @return [String]
      def serialize
        @ntp_header \
        + @unique_identifier.serialize \
        + @nts_cookie.serialize \
        + @nts_authenticator.serialize
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Sntp::Message]
      # rubocop: disable Metrics/AbcSize
      # rubocop: disable Metrics/CyclomaticComplexity
      # rubocop: disable Metrics/PerceivedComplexity
      def self.deserialize(s)
        raise Exception if s.length < 48

        ntp_header = s.slice(0, 48)
        i = 48
        while i < s.length
          raise Exception if i + 4 > s.length

          field_type = s.slice(i, 2).unpack1('n')
          value_len = s.slice(i + 2, 2).unpack1('n')
          raise Exception if i + value_len > s.length

          # `value_len` indicates the length of the entire extension field
          # in octets.
          sv = s.slice(i + 4, value_len - 4)
          case field_type
          when ExtensionFieldType::UNIQUE_IDENTIFIER
            unique_identifier = Extension::UniqueIdentifier.deserialize(sv)
          when ExtensionFieldType::NTS_COOKIE
            nts_cookie = Extension::NtsCookie.deserialize(sv)
          when ExtensionFieldType::NTS_COOKIE_PLACEHOLDER
            # TODO
            warn sv.bytes.map { |x| x.to_s(16).rjust(2, '0') }.join(' ')
          when ExtensionFieldType::NTS_AUTHENTICATOR
            nts_authenticator = Extension::NtsAuthenticator.deserialize(sv)
          else
            # TODO
            warn sv.bytes.map { |x| x.to_s(16).rjust(2, '0') }.join(' ')
          end
          i += value_len
        end
        raise Exception unless i == s.length

        Message.new(ntp_header, unique_identifier, nts_cookie,
                    nts_authenticator)
      end
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/CyclomaticComplexity
      # rubocop: enable Metrics/PerceivedComplexity
    end
  end
end
