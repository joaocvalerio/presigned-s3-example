module Devise
  module Strategies
    class JWTAuthenticatable < Base
      def valid?
        params_token || header_token
      end

      def authenticate!
        return fail! unless valid?

        success! find_record
      end

      private

      def params_token
        @token = params[:token]

        claims
      end

      def header_token
        return nil unless authorization = request.headers['Authorization']

        strategy, @token = authorization.split(' ')

        return nil unless strategy && strategy.downcase == 'bearer'

        claims
      end

      def claims
        jwt_value ||= WebToken.decode(@token) rescue nil

        if jwt_value
          @user_id = jwt_value['user_id']
        end
      end

      def find_record
       record_model.send('find_by_id', @user_id)
      end

      def record_model
        case scope
        when :user
          User
        end
      end
    end
  end
end
