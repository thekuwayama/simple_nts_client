# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe NtsAuthenticator do
  context 'initialized with nonce and ciphertext' do
    let(:nonce) do
      OpenSSL::Random.random_bytes(16)
    end

    let(:ciphertext) do
      OpenSSL::Random.random_bytes(12345)
    end

    let(:ex) do
      NtsAuthenticator.new(nonce, ciphertext)
    end

    it 'should be serialized' do
      expect(ex.nonce).to eq nonce
      expect(ex.ciphertext).to eq ciphertext
      expect(ex.padding_length).to eq 0

      expected = String.new
      expected << "\x04\x04\x30\x54" # Field Type | Length
      expected << "\x00\x10\x30\x3C" # Nonce Length | Ciphertext Length
      expected << nonce
      expected << ciphertext + "\x00\x00\x00" # padded to a word boundary
      expect(ex.serialize).to eq expected
    end
  end

  context 'received string' do
    let(:nonce) do
      OpenSSL::Random.random_bytes(16)
    end

    let(:ciphertext) do
      OpenSSL::Random.random_bytes(12345)
    end

    let(:ex) do
      NtsAuthenticator.deserialize(
        "\x00\x10\x30\x3C" \
        + nonce \
        + ciphertext + "\x00\x00\x00"
      )
    end

    it 'should be deserialized' do
      expect(ex.nonce).to eq nonce
      expect(ex.ciphertext).to eq ciphertext
      expect(ex.padding_length).to eq 0

      expected = String.new
      expected << "\x04\x04\x30\x54" # Field Type | Length
      expected << "\x00\x10\x30\x3C" # Nonce Length | Ciphertext Length
      expected << nonce
      expected << ciphertext + "\x00\x00\x00" # padded to a word boundary
      expect(ex.serialize).to eq expected
    end
  end
end
