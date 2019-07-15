# frozen_string_literal: true

module Nts
  module Sntp
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

Dir[File.dirname(__FILE__) + '/extension/*.rb'].each { |f| require f }
