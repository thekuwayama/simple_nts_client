# frozen_string_literal: true

module Nts
  module Sntp
    module Extension
      # https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19#section-5.6
      class NtsAuthenticator
        attr_reader :nonce, :ciphertext, :padding_length

        # @param nonce [String]
        # @param ciphertext [String]
        # @param padding_length [Integer]
        def initialize(nonce, ciphertext, padding_length = 0)
          @field_type = 5
          @nonce = nonce
          @ciphertext = ciphertext
          @padding_length = padding_length
        end

        # @return [String]
        def serialize
          pn = pad_zero(@nonce)
          pc = pad_zero(@ciphertext)
          value = [pn.length, pc.length].pack('n2') \
                  + pn + pc + ("\x00" * @padding_length)
          pv = pad_zero(value)
          length = pv.length + 4

          [@field_type, length].pack('n2') + pv
        end

        # @param s [String]
        #
        # @raise [Exception]
        #
        # @return [Nts::Sntp::Extension::NtsAuthenticator]
        def self.deserialize(s)
          raise Exception if s.length < 4

          nl = s.slice(0, 2).unpack1('n')
          cl = s.slice(2, 2).unpack1('n')
          nonce = truncate_zero_padding(s.slice(4, nl))
          ciphertext = truncate_zero_padding(s.slice(4 + nl, cl))
          padding_length = s.length - 4 - nl - cl
          NtsAuthenticator.new(nonce, ciphertext, padding_length)
        end
      end
    end
  end
end
