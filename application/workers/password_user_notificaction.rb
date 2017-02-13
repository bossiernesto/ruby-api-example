class Api
  module Workers
    class PasswordUserNotification
      include Sidekiq::Worker

      def perform(user_id)
        user = Backend::UserBackend.get_user user_id
        subject = 'Password updated successfully'
        body = "Dear #{user.first_name}, your password was successfully updated."

        mailer = Backend::MailerUserNotifier.create_mailer user.email, subject, body
        mailer.deliver!
      end
    end
  end
end
