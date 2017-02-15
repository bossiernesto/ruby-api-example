require 'spec_helper'

describe Api::Backend::UserBackend do

  context 'get user' do

    it 'should fail when querying a non existent user' do
      expect { described_class.get_user 7473743487 }.to raise_error(Api::Exceptions::UserNotFound)
    end

    it 'should return the user when querying an existant user' do
      expected_user = create(:user)
      user = described_class.get_user expected_user.id

      expect(expected_user).to eq user
    end
  end

  context 'get user by email' do

    it 'should fail when querying a non existent user' do
      expect { described_class.get_user_by_email 'a@a.com' }.to raise_error(Api::Exceptions::UserNotFound)
    end

    it 'should return the user when querying an existant user' do
      email = 'a@a.com'
      expected_user = create(:user, {email: email})
      user = described_class.get_user_by_email expected_user.email

      expect(expected_user).to eq user
    end

  end

  context 'create a new user' do
    let(:user) { create(:user) }
    let(:current_user) { user }

    before :each do
      stub_const("CreateUserNotification", double(perform_async: nil))
      login_as(user)
    end

    context 'failure tests' do

      it 'should fail with missing parameters' do
        params = {first_name: "John",
                  password: "apassword"
        }

        expect { described_class.create_user params }.to raise_error Api::Exceptions::ValidationError
      end

      it 'should fail with invalid type parameters' do
        params = {first_name: "John",
                  last_name: 2,
                  password: "apassword",
                  email: "a@gmail.com",
                  born_on: Date.parse("2000-01-01 00:00:00")
        }

        expect { described_class.create_user params }.to raise_error Api::Exceptions::ValidationError
      end

    end


    context 'successful tests' do
      it 'should create a valid user' do
        params = {first_name: "John",
                  last_name: "Doe",
                  password: "apassword31B",
                  email: "a@gmail.com",
                  born_on: Date.parse("2000-01-01 00:00:00")
        }

        user = described_class.create_user params

        expect(user.first_name).to eq('John')
        expect(user.last_name).to eq('Doe')
      end
    end

  end

  context 'update a user' do
    let(:params) { {first_name: "John",
                    last_name: "Doe",
                    password: "apassword",
                    email: "a@gmail.com",
                    born_on: Date.parse("2000-01-01 00:00:00")
    } }

    let(:user) { create(:user) }
    let(:current_user) { user }

    before :each do
      @params = params.merge(id: user.id)
    end

    context 'failure tests' do

      it 'should fail with missing parameters' do
        #missing the email attribute
        params = {first_name: "Jane",
                  last_name: "Dow",
                  id: user.id
        }

        expect { described_class.update_user current_user, params }.to raise_error Api::Exceptions::ValidationError
      end

      it 'should fail with invalid type parameters' do
        params = @params.merge ({first_name: "Jane",
                                 last_name: 2
                               })

        expect { described_class.update_user current_user, params }.to raise_error Api::Exceptions::ValidationError
      end

    end

    context 'successful tests' do
      it 'should update a valid user' do
        params = @params.merge({first_name: "Jane",
                                last_name: "Doe",
                                'id': user.id
                               })

        user = described_class.update_user(current_user, params)

        expect(user.first_name).to eq 'Jane'
        expect(user.last_name).to eq 'Doe'
      end
    end

  end


end