# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      class UniqueIdentifier
        attr_reader :id

        # @param id [String]
        def initialize(id = OpenSSL::Random.random_bytes(32))
          raise Exception if id.length < 32

          @field_type = 2
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
          UniqueIdentifier.new(truncate_zero_padding(s))
        end
      end
    end
  end
end
