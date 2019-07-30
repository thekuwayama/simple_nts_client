# frozen_string_literal: true

require 'optparse'

module Nts
  class CLI
    # rubocop: disable Metrics/MethodLength
    def parse_options(argv = ARGV)
      op = OptionParser.new

      # default value
      opts = {
        server: 'time.cloudflare.com',
        port: 1234,
        verbose: false
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

      op.on(
        '-v',
        '--verbose',
        "verbose mode       (default #{opts[:verbose]})"
      ) do |v|
        opts[:verbose] = v
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
    # rubocop: enable Metrics/MethodLength

    def run
      opts = parse_options

      # NTS-KE
      ntske_client = Ntske::Client.new(opts[:server], opts[:port])
      hostname, ntp_port, cookies, c2s_key, s2c_key = ntske_client.key_establish
      hostname ||= opts[:server]
      ntp_port ||= 123

      # verbose mode
      if opts[:verbose]
        puts "# NTPv4 Server          => #{hostname}"
        puts "# NTPv4 Port            => #{ntp_port}"
        puts "# Cookie for NTPv4(hex) => #{cookies.first.unpack1('H*')}"
        puts "# client-to-server(hex) => #{c2s_key.unpack1('H*')}"
        puts "# server-to-client(hex) => #{s2c_key.unpack1('H*')}"
      end

      # NTS protected NTP
      ntp_client = Nts::Sntp::Client.new(
        hostname,
        ntp_port,
        cookies.first,
        c2s_key,
        s2c_key
      )
      puts ntp_client.what_time
    end
  end
end
