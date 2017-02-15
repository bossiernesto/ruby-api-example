require 'spec_helper'

describe 'POST /api/users' do
  let!(:user) { create(:user) }

  before :each do
    stub_const("CreateUserNotification", double(perform_async: nil))
    login_as user
  end

  context 'Failing tests' do
    before :each do
      @params = {
          first_name: 'John',
          last_name:  'Doe',
          email:      'a@a.com',
          password:   nil
      }
    end

    it 'Should notice missing parameters' do
      #Send Nothing
      post 'api/v1.0/users', {}

      is_missing = ['is missing']

      expect(response_status).to eq 400
      expect(response_body[:errors][:first_name]).to eq is_missing
      expect(response_body[:errors][:last_name]).to eq is_missing
      expect(response_body[:errors][:email]).to eq is_missing
      expect(response_body[:errors][:password]).to eq is_missing

    end

    it 'Should notice nil paratemers' do
      params = @params.merge({email: nil, first_name: ''})
      post 'api/v1.0/users', params

      must_be_filled = ['must be filled']

      expect(response_status).to eq 400
      expect(response_body[:errors][:first_name]).to eq must_be_filled
      expect(response_body[:errors][:email]).to eq must_be_filled
    end

    it 'Should notice non email field' do
      params = @params.merge({password: 'apassword', email: 'invalidemail'})

      post 'api/v1.0/users', params

      expect(response_status).to eq 400
      expect(response_body[:errors][:email]).to eq ['must be an email']
    end

    it 'Should notice invalid type' do
      params = @params.merge({password: "uhe2373637273", first_name: {a:1}})

      post 'api/v1.0/users', params

      expect(response_status).to eq 400
      expect(response_body[:errors][:first_name]).to eq ["is invalid"]
    end

  end

  context 'Successful tests' do
    let(:params) { {first_name: "John",
                    last_name: "Doe",
                    password: "apassword",
                    email: "a@gmail.com",
                    born_on: "2000-01-01 00:00:00"
    } }

    it 'Create a normal user successfully' do
      post 'api/v1.0/users', params

      expect(response_status).to eq 201
      expect(response_body[:id]).not_to be_nil
      expect(response_body[:first_name]).to eq params[:first_name]
      expect(response_body[:last_name]).to eq params[:last_name]
    end

    it 'Create a normal user without date of birth' do
      params.delete :dob
      post 'api/v1.0/users', params

      expect(response_status).to eq 201
      expect(response_body[:id]).not_to be_nil
      expect(response_body[:first_name]).to eq params[:first_name]
      expect(response_body[:last_name]).to eq params[:last_name]
      expect(response_body[:dob]).to be_nil
    end
  end

end