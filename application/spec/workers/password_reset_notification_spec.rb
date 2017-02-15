require 'spec_helper'

describe Api::Workers::PasswordResetNotification do
  include Mail::Matchers

  before :all do
    Mail::TestMailer.deliveries.clear
  end

  it 'Send a mail to an inexistent user' do
    user_id = 37287827873
    token= 'atoken'

    expect { subject.perform user_id, token }.to raise_error(Api::Exceptions::UserNotFound)
  end

  it 'Send a successful mail to a user that has requested a password update' do
    #prep a user first
    email = 'a@a.com'
    token = 'atoken'
    user = create(:user, email: email, first_name: 'John', password: 'apass', reset_password_token: token)

    subject.perform user.id, token

    expect have_sent_email.from(SYSTEM_EMAIL)
               .to(email)
               .with_subject('Password Reset Request Token')
               .with_body("Dear #{user.first_name}, your password reset request has been processed. Your token is #{token} and expires in 1 hour.")
  end

end
