require 's3_reproxy_download/version'
require 'action_controller'
require 'active_support/configurable'
require 'aws-sdk'

module S3ReproxyDownload
  include ActiveSupport::Configurable

  config_accessor :reproxy_path, instance_reader: false, instance_writer: false do
    '/reproxy'
  end

  config_accessor :s3_client_options, instance_reader: false, instance_writer: false do
    {
      access_key_id:     ENV['AWS_ACCESS_KEY'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  end

  # for Backward compatible
  %w(access_key_id secret_access_key).each do |key|
    define_singleton_method "aws_#{key}".to_sym,  -> { s3_client_options[key.to_sym] }
    define_singleton_method "aws_#{key}=".to_sym, -> (value) { s3_client_options[key.to_sym] = value }
  end

  module Helper
    def send_s3_file(bucket_name, path, headers: {})
      s3_object = S3ReproxyDownload::S3Object.new(bucket_name, path)

      response.headers['X-Accel-Redirect'] = S3ReproxyDownload.reproxy_path
      response.headers['X-Reproxy-URL'] = s3_object.presigned_url
      response.headers['Content-Disposition'] = "attachment; filename=\"#{CGI.escape(s3_object.filename)}\""

      headers.each do |header, value|
        response.headers[header] = value
      end

      head :ok
    end
  end

  class S3Object
    def initialize(bucket_name, path)
      @bucket  = Aws::S3::Resource.new(client: client).bucket(bucket_name)
      @path    = path
    end

    def presigned_url
      @bucket.object(@path).presigned_url(:get)
    end

    def filename
      File.basename(@path)
    end

    private

    def client
      @client ||= Aws::S3::Client.new(S3ReproxyDownload.s3_client_options)
    end
  end
end
