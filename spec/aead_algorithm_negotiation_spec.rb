# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe AeadAlgorithmNegotiation do
  context 'initialized with AEAD_AES_SIV_CMAC_256' do
    let(:message) do
      AeadAlgorithmNegotiation.new([AeadAlgorithm::AEAD_AES_SIV_CMAC_256])
    end

    it 'should be serialized' do
      expect(message.algorithms).to eq [AeadAlgorithm::AEAD_AES_SIV_CMAC_256]
      expect(message.serialize).to eq "\x00\x04\x00\x02\x00\x0F"
    end
  end

  context 'received "\x00\x0f" means AEAD_AES_SIV_CMAC_256' do
    let(:message) do
      AeadAlgorithmNegotiation.deserialize("\x00\x0F")
    end

    it 'should be deserialized' do
      expect(message.algorithms).to eq [AeadAlgorithm::AEAD_AES_SIV_CMAC_256]
      expect(message.serialize).to eq "\x00\x04\x00\x02\x00\x0F"
    end
  end
end
