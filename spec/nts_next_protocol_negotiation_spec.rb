# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe NtsNextProtocolNegotiation do
  context 'initialized' do
    let(:message) do
      NtsNextProtocolNegotiation.new
    end

    it 'should be serialized' do
      expect(message.next_protocol).to eq "\x00\x00"
      expect(message.serialize).to eq "\x00\x01\x00\x02\x00\x00"
    end
  end

  context 'received "\x00\x00" that means NTPv4' do
    let(:message) do
      NtsNextProtocolNegotiation.deserialize("\x00\x00")
    end

    it 'should be deserialized' do
      expect(message.next_protocol).to eq "\x00\x00"
      expect(message.serialize).to eq "\x00\x01\x00\x02\x00\x00"
    end
  end
end
