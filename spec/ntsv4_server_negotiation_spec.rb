# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Ntsv4ServerNegotiation do
  context 'initialized with "localhost"' do
    let(:message) do
      Ntsv4ServerNegotiation.new('localhost')
    end

    it 'should be serialized' do
      expect(message.server).to eq 'localhost'
      expect(message.serialize).to eq "\x00\x06\x00\x09" + 'localhost'
    end
  end

  context 'received "localhost"' do
    let(:message) do
      Ntsv4ServerNegotiation.deserialize('localhost', false)
    end

    it 'should be deserialized' do
      expect(message.server).to eq 'localhost'
      expect(message.serialize).to eq "\x00\x06\x00\x09" + 'localhost'
    end
  end
end
