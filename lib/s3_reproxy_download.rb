require 's3_reproxy_download/version'
require 'action_controller'
require 'active_support/configurable'
require 'aws-sdk'

module S3ReproxyDownload
  include ActiveSupport::Configurable

  config_accessor :reproxy_path, instance_reader: false, instance_writer: false do
    '/reproxy'
  end

  config_accessor :aws_access_key_id, instance_reader: false, instance_writer: false do
    ENV['AWS_ACCESS_KEY']
  end

  config_accessor :aws_secret_access_key, instance_reader: false, instance_writer: false do
    ENV['AWS_SECRET_ACCESS_KEY']
  end

  module Helper
    def send_s3_file(bucket_name, path, headers: {})
      s3_object = S3ReproxyDownload::S3Object.new(bucket_name, path)

      response.headers['X-Accel-Redirect']    = S3ReproxyDownload.reproxy_path
      response.headers['X-Reproxy-URL']       = s3_object.presigned_url
      response.headers['Content-Disposition'] = "attachment; filename=\"#{s3_object.escaped_filename}\"; filename*=UTF-8''#{s3_object.escaped_filename}"

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

    def escaped_filename
      CGI.escape(filename)
    end

    private

    def client
      @client ||= Aws::S3::Client.new(
        access_key_id:     S3ReproxyDownload.aws_access_key_id,
        secret_access_key: S3ReproxyDownload.aws_secret_access_key
      )
    end
  end
end
