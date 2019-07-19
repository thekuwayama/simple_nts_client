# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      class UnknownExtension
        include Extension
        attr_reader :field_type
        attr_reader :value

        # @param value [String]
        # @param field_type [Integer]
        def initialize(value, field_type)
          @field_type = field_type
          @value = value
        end

        # @return [String]
        def serialize
          pv = pad_zero(@value)
          length = pv.length + 4

          [@field_type, length].pack('n2') + pv
        end

        # @param s [String]
        # @param field_type [Integer]
        #
        # @return [Nts::Sntp::Extension::UnknownExtension]
        def self.deserialize(s, field_type)
          UnknownExtension.new(Extension.truncate_zero_padding(s), field_type)
        end
      end
    end
  end
end
