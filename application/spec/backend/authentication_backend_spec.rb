require 'spec_helper'

describe Api::Backend::AuthenticationBackend do
  let(:params) { {email: 'a@a.com', password: 'genericpass123'} }

  describe 'Authenticate user/password (authenticate_user)' do

    before :each do
      @user = create(:user, params)
    end

    context 'Failure tests' do

      it 'User not Found' do
        expect { described_class.authenticate_user params.merge(email: 'b@a.com') }.to raise_error Api::Exceptions::UserNotFound
      end

      it 'Missing params' do
        expect { described_class.authenticate_user({email: 'a@a.com'}) }.to raise_error Api::Exceptions::ValidationError
      end

      it 'Invalid Password Authentication' do
        expect { described_class.authenticate_user params.merge(password: 'anotherpass') }.to raise_error Api::Exceptions::UnauthorizedUser
      end

    end

    context 'Success tests' do

      it 'Successful authentication' do
        token = described_class.authenticate_user params

        expect(token[:token]).to be_kind_of(String)
      end

    end

  end

  describe 'Resolve token to user id (get_user_id_from_token)' do

    context 'Failure tests' do

      it 'Invalid Token' do
        token = 'invalidToken'
        expect { described_class.get_user_id_from_token(token) }.to raise_error JWT::DecodeError
      end

      it 'Expired Token' do
        user = create(:user)
        payload = {user_id: user.id, exp: 30.minutes.ago.to_i}
        token = ::JWT.encode payload, HMAC_SECRET

        expect { described_class.get_user_id_from_token(token) }.to raise_error JWT::DecodeError
      end

    end

    context 'Success tests' do

      it 'Successful resolution' do
        user = create(:user)
        payload = {user_id: user.id, exp: 10.minutes.from_now.to_i}
        token = ::JWT.encode payload, HMAC_SECRET

        expect(described_class.get_user_id_from_token(token)).to eq(user.id)
      end

    end

  end

end