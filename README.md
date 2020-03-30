# WhiplashApiV2

Whiplash API V2 Client

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'whiplash_api_v2', git: 'https://github.com/tdmsinc/whiplash_api_v2'
```

And then execute:

    $ bundle

## Usage

```ruby
require 'whiplash_api_v2'

client = WhiplashApiV2::Client.new('ACCESS TOKEN')
client.order.count # => 100
cilent.order.all # => [{...},{...},{...}]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
