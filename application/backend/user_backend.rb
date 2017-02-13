class Api
  module Backend
    class UserBackend
      def self.get_user(user_id)
        user = Models::User.with_pk user_id
        raise Exceptions::UserNotFound unless user
        user
      end

      def self.get_user_by_email(email)
        user = Models::User.first(email: email)
        raise Exceptions::UserNotFound unless user
        user
      end

      def self.get_all_users()
        Models::User.all
      end

      def self.can_edit_user(current_user, user_id)
        user = self.get_user user_id
        raise Exceptions::CantEditUser unless current_user.can? :edit, user
        user
      end

      def self.create_user(current_user, params)
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

        user.update(password: result.output[:new_password])
        Workers::PasswordUserNotification.perform_async user.id
        user
      end

    end
  end
end