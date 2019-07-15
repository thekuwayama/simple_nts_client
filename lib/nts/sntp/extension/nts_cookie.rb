# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-5.4
      class NtsCookie
        include Extension
        attr_reader :cookie

        # @param cookie [String]
        def initialize(cookie)
          @field_type = 516
          @cookie = cookie
        end

        # @return [String]
        def serialize
          pc = pad_zero(@cookie)
          length = pc.length + 4

          [@field_type, length].pack('n2') + pc
        end

        # @param s [String]
        #
        # @return [Nts::Sntp::Extension::NtsCookie]
        def self.deserialize(s)
          NtsCookie.new(truncate_zero_padding(s))
        end
      end
    end
  end
end
