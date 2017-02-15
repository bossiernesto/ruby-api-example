require 'spec_helper'

describe 'PUT /api/users/:id' do
  let!(:user) { create(:user) }

  context 'Failing tests' do
    let(:new_mail) { 'b@a.com' }

    it 'should not update a user with missing parameters in input' do
      login_as(user)
      params = {email: new_mail, first_name: 'John'}

      put get_path_url(user.id), params

      expect(response_status).to eq 400
      expect(response_body[:errors][:last_name]).to eq ['is missing']
    end

    it 'should not update a user with nil parameters in input' do
      login_as(user)
      params = {email: nil, last_name: 'Doe', first_name: 'John'}

      put get_path_url(user.id), params

      expect(response_status).to eq 400
      expect(response_body[:errors][:email]).to eq ['must be filled']
    end

    it 'should not update a user with and invalid email in input' do
      login_as(user)
      params = {email: 'anemail', last_name: 'Doe', first_name: 'John'}

      put get_path_url(user.id), params

      expect(response_status).to eq 400
      expect(response_body[:errors][:email]).to eq ['must be an email']
    end

  end

  context 'Successful tests' do
    it 'Should update a user successfully' do
      login_as(user)
      new_mail = 'b@a.com'
      params = {email: new_mail, first_name: 'John', last_name: 'AnotherSurname'}

      put get_path_url(user.id), params

      expect(response_status).to eq 200
      expect(response_body[:id]).to eq user.id
      expect(response_body[:first_name]).to eq 'John'
      expect(response_body[:last_name]).to eq 'AnotherSurname'
      expect(response_body[:email]).to eq new_mail
      expect(response_body[:born_on]).to eq user.born_on.to_date.iso8601
    end

  end

  def get_path_url(user_id)
    "api/v1.0/users/#{user_id}"
  end
end
