class Api
  module Workers
    class PasswordResetNotification
      include ::Sidekiq::Worker

      def perform(user_id, token)
        user = Backend::UserBackend.get_user user_id
        subject = 'Password Reset Request Token'
        body = "Dear #{user.first_name}, your password reset request has been processed. Your token is #{token} and expires in 1 hour."

        mailer = Backend::MailerUserNotifier.create_mailer user.email, subject, body
        mailer.deliver!
      end
    end
  end
end
