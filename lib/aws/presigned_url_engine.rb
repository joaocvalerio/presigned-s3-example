module Aws
  module PresignedUrlEngine
    extend self

    def generate(prefix, filename)
      extname = File.extname(filename)
      filename = "#{SecureRandom.uuid}#{extname}"
      upload_key = Pathname.new(prefix).join(filename).to_s

      s3 = Aws::S3::Resource.new
      obj = s3.bucket('challenge-jcv').object(upload_key)

      {
        presigned_url: obj.presigned_url(
          :put,
          acl: 'public-read',
          content_length: 2
        ),
        public_url: obj.public_url
      }
    end
  end
end
