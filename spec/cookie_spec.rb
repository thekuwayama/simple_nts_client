# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Cookie do
  context 'initialized with random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:message) do
      Cookie.new(rb)
    end

    it 'should be serialized' do
      expect(message.cookie).to eq rb
      expect(message.serialize).to eq "\x00\x05\x00\x20" + rb
    end
  end

  context 'received random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:message) do
      Cookie.deserialize(rb, false)
    end

    it 'should be deserialized' do
      expect(message.cookie).to eq rb
      expect(message.serialize).to eq "\x00\x05\x00\x20" + rb
    end
  end
end
