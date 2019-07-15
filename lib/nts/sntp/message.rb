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
      def self.deserialize(s)
        # TODO
      end
    end
  end
end
