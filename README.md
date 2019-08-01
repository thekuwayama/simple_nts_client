# simple_nts_client

[![Build Status](https://travis-ci.org/thekuwayama/simple_nts_client.svg?branch=master)](https://travis-ci.org/thekuwayama/simple_nts_client)
[![Maintainability](https://api.codeclimate.com/v1/badges/7b34a4868f1e297af084/maintainability)](https://codeclimate.com/github/thekuwayama/simple_nts_client/maintainability)

`simple_nts_client` is CLI that is simple NTS(Network Time Security) Client implementation.

https://tools.ietf.org/html/draft-ietf-ntp-using-nts-for-ntp-19

## Quick Start

`simple_nts_client` requires Ruby version 2.6.1 or later. You can download and run it the following:

```bash
$ git clone git@github.com:thekuwayama/simple_nts_client.git

$ cd simple_nts_client

$ bundle install

$ bundle exec exe/simple_nts_client
```

## Usage

```bash
$ bundle exec exe/simple_nts_client --help
Usage: simple_nts_client [options]
    -s, --server VALUE               NTS-KE server name (default time.cloudflare.com)
    -p, --port VALUE                 NTS-KE port number (default 1234)
    -v, --verbose                    verbose mode       (default false)
```

You can run it the following:

```bash
$ bundle exec exe/simple_nts_client
2019-07-20 06:00:00 +0900
```

If you need to access other NTS-KE server or port, you can run it the following:

```bash
$ bundle exec exe/simple_nts_client -s YOURSERVER -p YOURPORT
2019-07-20 06:00:00 +0900
```

## License

The CLI is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
