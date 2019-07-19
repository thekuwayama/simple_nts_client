# frozen_string_literal: true

require __dir__ + '/extension.rb'

module Nts
  module Sntp
    # https://tools.ietf.org/html/rfc5905#section-7.3
    class Message
      attr_reader :ntp_header
      attr_reader :extensions

      # @param ntp_header [String] 48-octet NTP header(leap ~ xmt)
      # @param extensions [Array of Nts::Sntp::Extension::$Object]
      #
      # @raise [Exception]
      def initialize(ntp_header, extensions = [])
        @ntp_header = ntp_header
        @extensions = extensions

        raise 'extensions include only Sntp::Extension::$Object' \
          unless @extensions.all? do |ex|
            ex.class.ancestors.include?(Sntp::Extension)
          end
      end

      # @return [Nts::Sntp::Extension::UniqueIdentifier]
      def unique_identifier
        @extensions.find { |ex| ex.is_a?(Extension::UniqueIdentifier) }
      end

      # @return [Nts::Sntp::Extension::NtsCookie]
      def nts_cookie
        @extensions.find { |ex| ex.is_a?(Extension::NtsCookie) }
      end

      # @return [Nts::Sntp::Extension::NtsAuthenticator]
      def nts_authenticator
        @extensions.find { |ex| ex.is_a?(Extension::NtsAuthenticator) }
      end

      # @return [String]
      def serialize
        @ntp_header + @extensions.map(&:serialize).join
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Nts::Sntp::Message]
      def self.deserialize(s)
        raise Exception if s.length < 48

        ntp_header = s.slice(0, 48)
        extensions = extensions_deserialize(s[48..])

        Message.new(ntp_header, extensions)
      end

      # @param s [String]
      #
      # @raise [Exception]
      #
      # @return [Array of Nts::Sntp::Extension::$Object]
      # rubocop: disable Metrics/AbcSize
      # rubocop: disable Metrics/CyclomaticComplexity
      def self.extensions_deserialize(s)
        i = 0
        extensions = []
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
            extensions << Extension::UniqueIdentifier.deserialize(sv)
          when ExtensionFieldType::NTS_COOKIE
            extensions << Extension::NtsCookie.deserialize(sv)
          when ExtensionFieldType::NTS_COOKIE_PLACEHOLDER
            # unsupported NtsCookiePlaceholder
            warn sv.bytes.map { |x| x.to_s(16).rjust(2, '0') }.join(' ')
          when ExtensionFieldType::NTS_AUTHENTICATOR
            extensions << Extension::NtsAuthenticator.deserialize(sv)
          else
            extensions \
            << Extension::UnknownExtension.deserialize(sv, field_type)
          end
          i += value_len
        end
        raise Exception unless i == s.length

        extensions
      end
      # rubocop: enable Metrics/AbcSize
      # rubocop: enable Metrics/CyclomaticComplexity

      # @return [String]
      def origin_timestamp
        @ntp_header.slice(24, 8)
      end

      # @return [String]
      def receive_timestamp
        @ntp_header.slice(32, 8)
      end

      # @return [String]
      def transmit_timestamp
        @ntp_header.slice(40, 8)
      end
    end
  end
end
