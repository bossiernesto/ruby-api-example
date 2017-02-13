class Api
  module Workers
    class CreateUserNotification
      include Sidekiq::Worker

      def perform(user_id)
        user = Backend::UserBackend.get_user user_id
        subject = 'Account created successfully'
        body = "Dear #{user.first_name}, your account was successfully created."

        mailer = Backend::MailerUserNotifier.create_mailer user.email, subject, body
        mailer.deliver!
      end
    end
  end
end
