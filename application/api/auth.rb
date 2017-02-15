class Api
  resource :auth do
    desc 'Authenticate user',
         success: [200, Entities::Token],
         failure: [400, 403],
         authentication_needed: false
    params do
      requires :email, type: String, desc: 'Email'
      requires :password, type: String, desc: 'Password'
    end
    post do
      result = Backend::AuthenticationBackend.authenticate params
      present result, with: Entities::Token
    end

    route_param :id, type: Integer do
      desc 'Request a password reset',
           success: {code: 204},
           authentication_needed: false
      post 'request_password_reset' do
        Backend::AuthenticationBackend.request_password_reset params
        body false
      end
    end

  end
end
