class Api
  resource :auth do
    desc 'Login into API',
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
  end
end
