class Api
  module Backend
    class MailerUserNotifier
      def self.create_mailer(to_mail, subject, content)
        ::Mail.new do
          from SYSTEM_EMAIL
          to to_mail
          subject subject
          body content
        end
      end

    end
  end
end