require_relative 'base_validator'

class Api
  module Validators
    class UpdateUserPasswordValidator < BaseValidatorMixin
      validations do
        required(:new_password).filled(:str?)
        required(:confirm_password).filled(:str?)
        required(:token).filled(:str?)

        # Add a validation rule for checking that the new_password and confirm_password is the same.
        rule(password_confirmation: %i(new_password confirm_password)) do |new_password, confirm_password|
          new_password.eql?(confirm_password)
        end
      end
    end
  end
end
