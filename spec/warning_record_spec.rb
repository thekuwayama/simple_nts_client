# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe WarningRecord do
  context 'initialized with 1111' do
    let(:message) do
      WarningRecord.new(1111)
    end

    it 'should be serialized' do
      expect(message.warning_code).to eq 1111
      expect(message.serialize).to eq "\x80\x03\x00\x02\x04\x57"
    end
  end

  context 'received "\x04\x57"(=1111)' do
    let(:message) do
      WarningRecord.deserialize("\x04\x57")
    end

    it 'should be deserialized' do
      expect(message.warning_code).to eq 1111
      expect(message.serialize).to eq "\x80\x03\x00\x02\x04\x57"
    end
  end
end
