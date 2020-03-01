# frozen_string_literal: true

module Nts
  module Sntp
    # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-22#section-7.5
    module ExtensionFieldType
      UNIQUE_IDENTIFIER      = 260
      NTS_COOKIE             = 516
      NTS_COOKIE_PLACEHOLDER = 772
      NTS_AUTHENTICATOR      = 1028
    end

    # https://tools.ietf.org/html/rfc7822#section-3
    module Extension
      ZERO_PADDING = ['', "\x00\x00\x00", "\x00\x00", "\x00"].freeze

      module_function

      # @param s [String]
      #
      # @return [String]
      def pad_zero(s)
        s + ZERO_PADDING[s.length % 4]
      end

      # @param s [String]
      #
      # @return [String]
      def truncate_zero_padding(s)
        i = 1
        i += 1 while s[-i] == "\x00"
        s[0..-i]
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/extension/*.rb'].sort.each { |f| require f }
