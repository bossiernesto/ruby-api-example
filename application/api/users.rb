class Api
  resource :users do

    desc 'List all users',
         success: [200, Entities::User],
         authentication_needed: false
    params do
      includes :basic_search
    end
    get do
      users = Backend::UserBackend.get_all_users
      present users, with: Entities::User, root: 'data'
    end

    desc 'Creates a new user',
         sucess: [201, Entities::User],
         failure: [400, 401, 403],
         authentication_needed: true
    params do
      requires :first_name, type: String, desc: 'First name'
      requires :last_name, type: String, desc: 'Last name'
      requires :email, type: String, desc: 'Email'
      requires :password, type: String, desc: 'Password'
      optional :born_on, type: Date, desc: 'Date of birth'
    end
    post do
      #TODO: refactor this to a promise
      user = Api::Backend::UserBackend.create_user params
      present user, with: Entities::User
    end

    route_param :id do
      desc 'Update a user',
           success: [200, Entities::User],
           failure: [400, 401, 403, 404]
      # authentication_needed: true
      params do
        requires :first_name, type: String, desc: 'First name'
        requires :last_name, type: String, desc: 'Last name'
        requires :email, type: String, desc: 'Email'
        optional :born_on, type: Date, desc: 'Date of birth'
      end

      put do
        user = Api::Backend::UserBackend.update_user current_user, params
        present user, with: Entities::User
      end

      desc 'Update a users password',
           sucess: [204], #dont send content a 204 is enough that password update is correct
           failure: [400, 401, 403, 404]
      params do
        requires :id, type: Integer
        requires :new_password, type: String, desc: 'New password'
        requires :confirm_password, type: String, desc: 'Confirm password'
        requires :token, type: String, desc: 'Token for password reset'
      end
      patch :update_password do
        Api::Backend::UserBackend.update_password current_user, params
        body false
      end
    end
  end
end
