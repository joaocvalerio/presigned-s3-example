module V1
  module Users
    class UpdateService < BaseService
      attr_accessor :name
      attr_accessor :password
      attr_accessor :email
      attr_accessor :profile_picture_file_name
      attr_accessor :presigned_object

      attr_accessor :user

      validates :user, presence: true

      def call_after_validation
        fetch_profile_picture_url if profile_picture_file_name
        update_user

        return valid?
      end

      def fetch_profile_picture_url
        @presigned_object = Aws::PresignedUrlEngine.generate(
          profile_picture_file_name
        )
      end

      def update_user
        params = {
          name: name,
          email: email,
          password: password
        }

        params[:profile_picture_url] = @presigned_object[:public_url] if @presigned_object

        user.update_attributes(params.reject { |_k, v| v.nil? })
      end

      def valid?
        return false unless super

        clone_errors(@user)

        @errors.empty?
      end
    end
  end
end
