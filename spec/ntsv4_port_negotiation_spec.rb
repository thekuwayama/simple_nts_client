# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Ntsv4PortNegotiation do
  context 'initialized with 123' do
    let(:message) do
      Ntsv4PortNegotiation.new(123)
    end

    it 'should be serialized' do
      expect(message.port).to eq 123
      expect(message.serialize).to eq "\x00\x07\x00\x02\x00\x7B"
    end
  end

  context 'received "\x00\x7B"(=123)' do
    let(:message) do
      Ntsv4PortNegotiation.deserialize("\x00\x7B")
    end

    it 'should be deserialized' do
      expect(message.port).to eq 123
      expect(message.serialize).to eq "\x00\x07\x00\x02\x00\x7B"
    end
  end
end
