# frozen_string_literal: true

module Nts
  module Ntske
    module AeadAlgorithm
      AEAD_AES_128_GCM      = "\x00\x01"
      AEAD_AES_256_GCM      = "\x00\x02"
      AEAD_AES_128_CCM      = "\x00\x03"
      AEAD_AES_256_CCM      = "\x00\x04"
      AEAD_AES_SIV_CMAC_256 = "\x00\x0F"
    end

    class AeadAlgorithmNegotiation < Record
      attr_reader :algorithms

      # @param [Array of Nts::Ntske::AeadAlgorithm constants]
      #
      # example:
      #     AeadAlgorithmNegotiation.new([
      #         AeadAlgorithm::AEAD_AES_128_GCM,
      #         AeadAlgorithm::AEAD_AES_SIV_CMAC_256,
      #     ])
      def initialize(algorithms)
        super(false, 4)
        @algorithms = algorithms
      end

      def self.deserialize(s)
        raise Exception unless (s.length % 2).zero?

        AeadAlgorithmNegotiation.new(s.scan(/.{2}/))
      end

      private

      # @return [String]
      def serialize_body
        @algorithms.join
      end
    end
  end
end
