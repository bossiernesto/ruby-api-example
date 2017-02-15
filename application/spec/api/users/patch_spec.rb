require 'spec_helper'

describe 'PATCH /api/users/:id/update_password' do
  let(:token) { "VAL1DT0KEN" }
  let(:exp) { 1.hours.from_now }
  let!(:user) { create(:user, reset_password_token: token, reset_password_token_exp: exp) }

  before :each do
    stub_const("PasswordUserNotification", double(perform_async: nil))
    login_as user
  end

  context 'Failing tests' do
    let(:params) {{token: token, confirm_password: 'newpass', new_password: 'newpass'}}

    it 'Can not update another user password' do
      another_user = create(:user)

      patch get_path_url(another_user.id), params

      expect(response_status).to eq 403
      expect(response_body[:errors][:forbidden]).to eq 'Unauthorized User'
    end

    it 'passwords dont match' do
      _params = params.merge({confirm_password: 'another_pass'})

      patch get_path_url(user.id), _params

      expect(response_status).to eq 400
      expect(response_body[:errors][:password_confirmation]).to eq ["passwords dont match"]
    end

    it 'invalid token' do
      _params = params.merge({token: 'ANOTHER'})

      patch get_path_url(user.id), _params

      expect(response_status).to eq 401
      expect(response_body[:errors][:unauthorized]).to eq 'Unauthorized User'
    end

    context 'expired token' do
      let(:exp) {10.minutes.ago}

      it 'expired token' do
        patch get_path_url(user.id), params

        expect(response_status).to eq 401

        expect(response_body[:errors][:unauthorized]).to eq 'Unauthorized User'
      end
    end
  end

  context 'Successful tests' do
    it 'update a user password successfully' do
      params = {token: token, confirm_password: 'newpass', new_password: 'newpass'}

      patch get_path_url(user.id), params

      expect(response_status).to eq 204
    end
  end

  def get_path_url(user_id)
    "api/v1.0/users/#{user_id}/update_password"
  end
end
