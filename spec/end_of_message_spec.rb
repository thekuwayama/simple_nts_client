# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe EndOfMessage do
  context 'initialized' do
    let(:message) do
      EndOfMessage.new
    end

    it 'should be serialized' do
      expect(message.serialize).to eq "\x80\x00\x00\x00"
    end
  end

  context 'received empty string' do
    let(:message) do
      EndOfMessage.deserialize('')
    end

    it 'should be deserialized' do
      expect(message.serialize).to eq "\x80\x00\x00\x00"
    end
  end
end
