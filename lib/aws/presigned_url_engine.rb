module Aws
  module PresignedUrlEngine
    extend self

    def generate(filename)
      extname = File.extname(filename)
      # filename = "#{SecureRandom.uuid}#{extname}"
      # upload_key = Pathname.new(prefix).join(filename).to_s

      s3 = Aws::S3::Resource.new
      obj = s3.bucket('challenge-jcv').object(filename)
      {
        presigned_url: obj.presigned_url(
          :put,
          acl: 'public-read'
        ),
        public_url: obj.public_url,
        content_type: "image/#{extname.gsub(/\./mi, '')}",
      }
    end
  end
end
