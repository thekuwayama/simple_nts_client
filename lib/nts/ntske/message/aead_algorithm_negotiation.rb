# encoding: ascii-8bit
# frozen_string_literal: true

module Nts
  module Ntske
    module AeadAlgorithm
      AEAD_AES_SIV_CMAC_256 = "\x00\x0F"
    end

    class AeadAlgorithmNegotiation < Record
      attr_reader :algorithms

      # @param algorithms [Array of Nts::Ntske::AeadAlgorithm constants]
      # @param c [Boolean]
      #
      # example:
      #     AeadAlgorithmNegotiation.new([
      #         AeadAlgorithm::AEAD_AES_SIV_CMAC_256
      #     ])
      def initialize(algorithms, c = false)
        super(c, 4)
        @algorithms = algorithms
      end

      # @param s [String]
      # @param c [Boolean]
      #
      # @raise [Exception]
      #
      # @return [Nts::Ntske::AeadAlgorithmNegotiation]
      def self.deserialize(s, c)
        raise Exception unless (s.length % 2).zero?

        AeadAlgorithmNegotiation.new(s.scan(/.{2}/), c)
      end

      private

      # @return [String]
      def serialize_body
        @algorithms.join
      end
    end
  end
end
