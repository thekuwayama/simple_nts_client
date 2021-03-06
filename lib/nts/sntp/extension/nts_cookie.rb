# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      # https://tools.ietf.org/html/rfc8915#section-5.4
      class NtsCookie
        include Extension
        attr_reader :cookie

        # @param cookie [String]
        def initialize(cookie)
          @field_type = ExtensionFieldType::NTS_COOKIE
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
          NtsCookie.new(Extension.truncate_zero_padding(s))
        end
      end
    end
  end
end
