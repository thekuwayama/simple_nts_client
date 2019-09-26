# simple_nts_client

[![Gem Version](https://badge.fury.io/rb/simple_nts_client.svg)](https://badge.fury.io/rb/simple_nts_client)
[![Build Status](https://travis-ci.org/thekuwayama/simple_nts_client.svg?branch=master)](https://travis-ci.org/thekuwayama/simple_nts_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/7b34a4868f1e297af084/maintainability)](https://codeclimate.com/github/thekuwayama/simple_nts_client/maintainability)

simple\_nts\_client is CLI that is simple NTS(Network Time Security) Client implementation.
This CLI prints the now timestamp got with NTS.
Current implementation is based on:

* [draft-ietf-ntp-using-nts-for-ntp-20](https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-20)


## Installation

The gem is available at [rubygems.org](https://rubygems.org/gems/simple_nts_client). You can install it the following:

```bash
$ gem install simple_nts_client
```


## Usage

```bash
$ simple_nts_client --help
Usage: simple_nts_client [options]
    -s, --server VALUE               NTS-KE server name (default time.cloudflare.com)
    -p, --port VALUE                 NTS-KE port number (default 1234)
    -v, --verbose                    verbose mode       (default false)
```

You can run it the following:

```bash
$ simple_nts_client
2019-07-20 06:00:00 +0900
```

If you need to access other NTS-KE server or port, you can run it the following:

```bash
$ simple_nts_client --server YOURSERVER --port YOURPORT
2019-07-20 06:00:00 +0900
```


## How "simple" client?

* The CLI supports only `AEAD_AES_SIV_CMAC_256` as AEAD algorithms to protect the NTPv4 packet.
* The CLI sends the first one of the received cookies via the response of the New Cookie for NTPv4 record and discards cookies that didn't send.
* The CLI just prints the timestamp adjusted by calculated system clock offset.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
