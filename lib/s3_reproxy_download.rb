require 's3_reproxy_download/version'
require 'action_controller'
require 'aws-sdk'

module S3ReproxyDownload
  def self.reproxy_path=(path)
    @reproxy_path = path
  end

  def self.reproxy_path
    @reproxy_path || '/reproxy'
  end

  module Helper
    def send_s3_file(bucket_name, path, headers: {})
      s3_object = S3ReproxyDownload::S3Object.new(bucket_name, path)

      response.headers['X-Accel-Redirect'] = S3ReproxyDownload.reproxy_path
      response.headers['X-Reproxy-URL'] = s3_object.presigned_url
      response.headers['Content-Disposition'] = "attachment; filename=\"#{s3_object.filename}\""

      headers.each do |header, value|
        response.headers[header] = value
      end

      head :ok
    end
  end

  class S3Object
    def initialize(bucket_name, path)
      @bucket  = Aws::S3::Resource.new.bucket(bucket_name)
      @path    = path
    end

    def presigned_url
      @bucket.object(@path).presigned_url(:get, @path)
    end

    def filename
      File.basename(@path)
    end
  end
end
