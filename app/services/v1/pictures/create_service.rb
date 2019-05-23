module V1
  module Pictures
    class CreateService < BaseService
      attr_accessor :picture_file_name
      attr_accessor :presigned_object
      attr_accessor :user

      attr_accessor :picture

      validates :user, :picture_file_name, presence: true

      def call_after_validation
        fetch_profile_picture_url
        create_picture

        return valid?
      end

      def fetch_profile_picture_url
        @presigned_object = Aws::PresignedUrlEngine.generate(
          picture_file_name
        )
      end

      def create_picture
        return unless @presigned_object

        @picture = Picture.create(
          user_id: user.id,
          url: @presigned_object[:public_url]
        )
      end

      def valid?
        return false unless super

        clone_errors(@picture)

        @errors.empty?
      end
    end
  end
end
