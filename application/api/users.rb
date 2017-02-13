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
      present users, with: Entities::User
    end

    # The 422 (Unprocessable Entity) status code means the server understands the content type of the request entity
    # (hence a 415 (Unsupported Media Type) status code is inappropriate), and the syntax of the request entity is correct
    # (thus a 400 (Bad Request) status code is inappropriate) but was unable to process the contained instructions.
    # For example, this error condition may occur if an XML request body contains well-formed (i.e., syntactically correct),
    # but semantically erroneous, XML instructions.
    desc 'Creates a new user',
         sucess: [201, Entities::User],
         failure: [400, 401, 403, 422],
         authentication_needed: true
    params do
      requires :first_name, type: String, desc: 'First name'
      requires :last_name, type: String, desc: 'Last name'
      requires :email, type: String, desc: 'Email'
      requires :password, type: String, desc: 'Password'
      optional :born_on, type: Date, desc: 'Date of birth'
    end
    post do
      #TODO: refactor this to a class
      user = Backend::UserBackend.create_user current_user, params
      present user, with: Entities::User
    end
  end

  route_param :id, type: Integer do
    desc 'Update a user',
         success: [200, Entities::User],
         failure: [400, 401, 403, 404, 422],
         authentication_needed: true
    params do
      optional :first_name, type: String, desc: 'First name'
      optional :last_name, type: String, desc: 'Last name'
      optional :email, type: String, desc: 'Email'
      optional :born_on, type: Date, desc: 'Date of birth'
    end
    put do
      user = Backend::UserBackend.update_user current_user, params
      present user, with: Entities::User
    end

    desc 'Update a users password',
         sucess: [200, Entities::User],
         failure: [400, 401, 403, 404, 422],
         authentication_needed: true
    params do
      requires :new_password, type: String, desc: 'New password'
      requires :confirm_password, type: String, desc: 'Confirm password'
    end
    patch 'reset_password' do
      user = Backend::UserBackend.update_password current_user, params

      present user, with: Entities::User
    end

  end

end
