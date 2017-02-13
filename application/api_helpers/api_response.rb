class Api
  module ApiResponse
    extend Grape::API::Helpers

    def api_response response
      if response.key? :error_type
        case response[:error_type].to_sym
          when :unauthorized
            status 401
          when :forbidden
            status 403
          when :not_found
            status 404
          when :invalid, :unprocessable_entity
              status 422
          else
            status 400
        end
      else
        status 200
      end
      response
    end
  end
end
