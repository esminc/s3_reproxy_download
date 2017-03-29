# S3ReproxyDownload

Provide helper method that S3 file download use X-REPROXY-URL

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_reproxy_download'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_reproxy_download

## Usage

First, include `S3ReproxyDownload::Helper` module to your controller.

```ruby
  class YourController
    include S3ReproxyDownload::Helper
  end
```

Call `send_s3_file` method.

```ruby
  class YourController
    include S3ReproxyDownload

    def show
      send_s3_file :your_bucket, :file_key
    end
  end
```

If you want to set custom headers, you should use `headers` option.

```ruby
  class YourController
    include S3ReproxyDownload

    def show
      send_s3_file :your_bucket, :file_key, headers: {'X-CUSTOM-HEADER' => 'custom'}
    end
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/esminc/s3_reproxy_download.
