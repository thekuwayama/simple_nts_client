# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe ErrorRecord do
  context 'initialized with BAD_REQUEST' do
    let(:message) do
      ErrorRecord.new(ErrorCode::BAD_REQUEST)
    end

    it 'should be serialized' do
      expect(message.error_code).to eq ErrorCode::BAD_REQUEST
      expect(message.serialize).to eq "\x80\x02\x00\x02\x00\x01"
    end
  end

  context 'received "\x00\x01" that means "Bad Request"' do
    let(:message) do
      ErrorRecord.deserialize("\x00\x01")
    end

    it 'should be deserialized' do
      expect(message.error_code).to eq ErrorCode::BAD_REQUEST
      expect(message.serialize).to eq "\x80\x02\x00\x02\x00\x01"
    end
  end
end
