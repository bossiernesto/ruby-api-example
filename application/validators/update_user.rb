require_relative 'base_validator'

class Api
  module Validators
    class UpdateUserValidator < BaseValidatorMixin
      validations do
        required(:first_name).filled(:str?)
        required(:last_name).filled(:str?)
        required(:email).filled(:str?, :email?)
        optional(:born_on).filled(:date?)
      end
    end
  end
end


