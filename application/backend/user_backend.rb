class Api
  module Backend
    class UserBackend
      def self.get_user(user_id)
        user = Models::User.with_pk user_id
        raise Exceptions::UserNotFound.new unless user
        user
      end

      def self.get_user_by_email(email)
        user = Models::User.first(email: email)
        raise Exceptions::UserNotFound.new unless user
        user
      end

      def self.get_all_users()
        Models::User.all
      end

      def self.can_edit_user(current_user, user_id)
        user = self.get_user user_id
        raise Exceptions::CantEditUser.new 'Unauthorized user', {forbidden: 'Unauthorized User'} unless current_user.can? :edit, user
        user
      end

      def self.create_user(params)
        result = Validators::CreateUserValidator.new(params).validate
        raise Exceptions::ValidationError.new 'Create user validation error', result.errors unless result.success?

        user = Models::User.create(result.output)
        Workers::CreateUserNotification.perform_async user.id
        user
      end

      def self.update_user(current_user, params)
        user = self.can_edit_user current_user, params[:id]
        result = Validators::UpdateUserValidator.new(params).validate
        raise Exceptions::ValidationError.new 'Update user validation error', result.errors unless result.success?

        #update it
        user.update result.output

        user
      end

      def self.update_password(current_user, params)
        user = self.can_edit_user current_user, params[:id]

        result = Validators::UpdateUserPasswordValidator.new(params).validate
        raise Exceptions::ValidationError.new 'Update user password validation error', result.errors unless result.success?

        token = result.output[:token]

        is_token_valid = lambda { |code, model_user|
          code.upcase === model_user.reset_password_token && Time.now <= model_user.reset_password_token_exp }

        raise Exceptions::UnauthorizedUser.new unless is_token_valid.call(token, user)

        user.update(password: result.output[:new_password], reset_password_token: nil)
        Workers::PasswordUserNotification.perform_async user.id
        user
      end

    end
  end
end