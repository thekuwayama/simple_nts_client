# frozen_string_literal: true

require 'optparse'

module Nts
  class CLI
    def parse_options(argv = ARGV)
      op = OptionParser.new

      # default value
      opts = {
        server: 'time.cloudflare.com',
        port: 1234
      }

      op.on(
        '-s',
        '--server VALUE',
        "NTS-KE server name (default #{opts[:server]})"
      ) do |v|
        opts[:server] = v
      end

      op.on(
        '-p',
        '--port VALUE',
        "NTS-KE port number (default #{opts[:port]})"
      ) do |v|
        opts[:port] = v
      end

      begin
        op.parse(argv)
      rescue OptionParser::InvalidOption => e
        puts op.to_s
        puts "error: #{e.message}"
        exit 1
      end

      opts
    end

    def run
      opts = parse_options

      # NTS-KE
      ntske_client = Ntske::Client.new(opts[:server], opts[:port])
      hostname, ntp_port, cookies, c2s_key, s2c_key = ntske_client.key_establish

      # NTS protected NTP
      ntp_client = Nts::Sntp::Client.new(
        hostname || opts[:server],
        ntp_port || 123,
        cookies.first,
        c2s_key,
        s2c_key
      )
      puts ntp_client.what_time
    end
  end
end
