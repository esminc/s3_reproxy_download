# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 's3_reproxy_download/version'

Gem::Specification.new do |spec|
  spec.name          = "s3_reproxy_download"
  spec.version       = S3ReproxyDownload::VERSION
  spec.authors       = ["takkanm", "hide_nba", "hrysd"]
  spec.email         = ["takkanm@gmail.com"]

  spec.summary       = %q{provide helper method that S3 file downloade use X-REPROXY-URL}
  spec.description   = %q{provide helper method that S3 file downloade use X-REPROXY-URL}
  spec.homepage      = "https://github.com/esminc/s3_reproxy_download"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'actionpack'
  spec.add_dependency 'activesupport'
  spec.add_dependency 'aws-sdk'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
