require 'spec_helper'

describe Api::Workers::PasswordUserNotification do
  include Mail::Matchers

  before :all do
    Mail::TestMailer.deliveries.clear
  end

  it 'Send a mail to an inexistent user' do
    user_id = 37287827873
    expect { subject.perform user_id }.to raise_error(Api::Exceptions::UserNotFound)
  end

  it 'Send a successful mail to a user that has updated his password' do
    #prep a user first
    email = 'a@a.com'
    user = create(:user, email: email, first_name: 'John', password: 'apass')

    subject.perform user.id

    expect have_sent_email.from(SYSTEM_EMAIL)
               .to(email)
               .with_subject('Password updated successfully')
               .with_body("Dear #{user.first_name}, your password was successfully updated.")
  end

end
