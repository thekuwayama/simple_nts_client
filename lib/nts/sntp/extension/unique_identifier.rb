# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-20#section-5.3
      class UniqueIdentifier
        include Extension
        attr_reader :id

        # @param id [String]
        def initialize(id = OpenSSL::Random.random_bytes(32))
          raise Exception if id.length < 32

          @field_type = ExtensionFieldType::UNIQUE_IDENTIFIER
          @id = id
        end

        # @return [String]
        def serialize
          pi = pad_zero(@id)
          length = pi.length + 4

          [@field_type, length].pack('n2') + pi
        end

        # @param s [String]
        #
        # @return [Nts::Sntp::Extension::UniqueIdentifier]
        def self.deserialize(s)
          UniqueIdentifier.new(Extension.truncate_zero_padding(s))
        end
      end
    end
  end
end
