Encoding.default_external = 'UTF-8'

$LOAD_PATH.unshift(File.expand_path('./application'))

# Include critical gems
require 'config/variables'

if %w(development test).include?(RACK_ENV)
  require 'pry'
  require 'awesome_print'
end

require 'bundler'
Bundler.setup :default, RACK_ENV
require 'rack/indifferent'
require 'grape'
require 'grape/batch'

# Initialize the application so we can add all our components to it
class Api < Grape::API;
end

# Include all config files
require 'config/sequel'
require 'config/hanami'
require 'config/grape'
require 'config/mailer'

# require some global libs
require 'lib/core_ext'
require 'lib/time_formats'
require 'lib/io'
require 'lib/fixnum_ext'
require 'lib/pretty_logger'

# load active support helpers
require 'active_support'
require 'active_support/core_ext'

require 'jwt'
require 'sidekiq'
require 'securerandom'


#Add entities for managing input
Dir['./application/entities/*.rb'].each { |rb| require rb }

# require all models
Dir['./application/models/*.rb'].each { |rb| require rb }
Dir['./application/api_helpers/**/*.rb'].each { |rb| require rb }

#Validators and Exceptions for
Dir['./application/validators/*.rb'].each { |rb| require rb
Dir['./application/backend/*.rb'].each { |rb| require rb }
Dir['./application/exceptions/*.rb'].each { |rb| require rb }

# Add the workers jobs for email notifications
Dir['./application/workers/*.rb'].each { |rb| require rb }

}

class Api < Grape::API
  version 'v1.0', using: :path
  content_type :json, 'application/json'
  content_type :txt, 'text/plain'
  default_format :json
  prefix :api

  logger PrettyLogger.logger

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    ret = {error_type: 'validation', errors: {}}
    e.each do |x, err|
      ret[:errors][x[0]] ||= []
      ret[:errors][x[0]] << err.message
    end
    error! ret, 400
  end

  rescue_from Exceptions::ValidationError do |e|
    ret = {error_type: 'validation', errors: e.errors}
    error! ret, 400
  end

  rescue_from Exceptions::UserNotFound do |e|
    ret = {error_type: :not_found, errors: {not_found: e.message}}
    error! ret, 404
  end

  rescue_from Exceptions::UnauthorizedUser do |e|
    ret = {error_type: :unauthorized, errors: {unauthorized: e.message}}
    error! ret, 401
  end

  rescue_from JWT::DecodeError do |e|
    ret = {error_type: :unauthorized, errors: {decode_error: e.message}}
    error! ret, 401
  end

  rescue_from Exceptions::CantEditUser do |e|
    ret = {error_type: :forbidden, errors: e.errors}
    error! ret, 403
  end

  helpers SharedParams
  helpers ApiResponse
  include Auth

  before do
    authenticate! if requires_auth?
  end

  Dir['./application/api_entities/**/*.rb'].each { |rb| require rb }
  Dir['./application/api/**/*.rb'].each { |rb| require rb }

  # add_swagger_documentation mount_path: '/docs'
end
