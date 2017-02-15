class Api
  module Backend
    class AuthenticationBackend
      def self.authenticate_user(params)

        result = Validators::LoginUserValidator.new(params).validate
        raise Exceptions::ValidationError.new('Login user validation error', result.errors) unless result.success?

        email = result.output[:email]
        password = result.output[:password]

        user = Backend::UserBackend.get_user_by_email email
        raise Exceptions::UnauthorizedUser.new unless user.authenticate password

        payload = {
            user_id: user.id,
            exp: AUTHENTICATION_DURATION.hours.from_now.to_i
        }

        {token: ::JWT.encode(payload, HMAC_SECRET)}
      end

      def self.get_user_id_from_token(token)
        token = ::JWT.decode(token, HMAC_SECRET, true, algorithm: 'HS256')
        token.first["user_id"]
      end

      def self.request_password_reset(params)
        id = params[:id]
        user = Backend::UserBackend.get_user id

        token = SecureRandom.hex(10).upcase.tap do |token|
          user.update({reset_password_token: token, reset_password_token_exp: 1.hours.from_now})
        end

        Workers::PasswordResetNotification.perform_async user.id, token
      end

    end
  end
end