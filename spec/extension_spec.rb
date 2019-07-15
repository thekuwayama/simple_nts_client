# encoding: ascii-8bit
# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Nts::Sntp::Extension do
  context 'module_function :pad_zero' do
    it 'should pad "\x00" to a word boundary' do
      expect(Extension.pad_zero("\xFF")).to eq "\xFF\x00\x00\x00"
      expect(Extension.pad_zero("\xFF\xFF")).to eq "\xFF\xFF\x00\x00"
      expect(Extension.pad_zero("\xFF\xFF\xFF")).to eq "\xFF\xFF\xFF\x00"
      expect(Extension.pad_zero("\xFF\xFF\xFF\xFF")).to eq "\xFF\xFF\xFF\xFF"
    end
  end

  context 'module_function :truncate_zero_padding' do
    it 'should truncate "\x00"' do
      expect(Extension.truncate_zero_padding("\xFF\x00\x00\x00"))
        .to eq "\xFF"
      expect(Extension.truncate_zero_padding("\xFF\xFF\x00\x00"))
        .to eq "\xFF\xFF"
      expect(Extension.truncate_zero_padding("\xFF\xFF\xFF\x00"))
        .to eq "\xFF\xFF\xFF"
      expect(Extension.truncate_zero_padding("\xFF\xFF\xFF\xFF"))
        .to eq "\xFF\xFF\xFF\xFF"
    end
  end
end
