# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe UnknownExtension do
  context 'initialized with random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:field_type) do
      12345
    end

    let(:ex) do
      UnknownExtension.new(rb, field_type)
    end

    it 'should be serialized' do
      expect(ex.field_type).to eq field_type
      expect(ex.value).to eq rb
      expect(ex.serialize).to eq "\x30\x39\x00\x24" + rb
    end
  end

  context 'received random binary' do
    let(:rb) do
      OpenSSL::Random.random_bytes(32)
    end

    let(:field_type) do
      12345
    end

    let(:ex) do
      UnknownExtension.deserialize(rb, field_type)
    end

    it 'should be deserialized' do
      expect(ex.field_type).to eq field_type
      expect(ex.value).to eq rb
      expect(ex.serialize).to eq "\x30\x39\x00\x24" + rb
    end
  end
end
