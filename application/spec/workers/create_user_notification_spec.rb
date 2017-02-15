require 'spec_helper'

describe Api::Workers::CreateUserNotification do
  include Mail::Matchers

  before :all do
    Mail::TestMailer.deliveries.clear
  end

  it 'Send a mail to an inexistent user' do
    user_id = 37287827873
    expect { subject.perform user_id }.to raise_error(Api::Exceptions::UserNotFound)
  end

  it 'Send a successful mail to a new user' do
    #prep a user first
    email = 'a@a.com'
    user = create(:user, email: email, first_name: 'John')

    subject.perform user.id

    expect have_sent_email.from(SYSTEM_EMAIL)
               .to(email)
               .with_subject('Account created successfully')
               .with_body("Dear #{user.first_name}, your account was successfully created.")
  end

end
