# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe UniqueIdentifier do
  context 'initialized with random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:ex) do
      UniqueIdentifier.new(rb)
    end

    it 'should be serialized' do
      expect(ex.id).to eq rb
      expect(ex.serialize).to eq "\x00\x02\x00\x24" + rb
    end
  end

  context 'received random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:ex) do
      UniqueIdentifier.deserialize(rb)
    end

    it 'should be deserialized' do
      expect(ex.id).to eq rb
      expect(ex.serialize).to eq "\x00\x02\x00\x24" + rb
    end
  end
end
