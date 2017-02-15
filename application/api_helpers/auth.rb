class Api
  module Auth
    extend ActiveSupport::Concern

    included do |base|
      helpers HelperMethods
    end

    module HelperMethods
      def authenticate!
        begin
          token = headers['Authorization']

          return current_user if current_user and token.nil?

          raise Exceptions::UnauthorizedUser.new unless token

          user_id = Backend::AuthenticationBackend.get_user_id_from_token token
          @current_user = Backend::UserBackend.get_user user_id
        rescue JWT::DecodeError
          error!({error_type: :unauthorized}, :unauthorized)
        end
      end

      def current_user
        @current_user
      end

      def requires_auth?
        self.route.settings[:description][:authentication_needed] rescue false
      end

    end
  end
end
