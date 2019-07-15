# encoding: ascii-8bit
# frozen_string_literal: true

RSpec.configure(&:disable_monkey_patching!)

# rubocop: disable Style/MixinUsage
require 'nts'
include Nts::Ntske
include Nts::Sntp
include Nts::Sntp::Extension
# rubocop: enable Style/MixinUsage
