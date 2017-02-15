class Api
  module Validators
    class LoginUserValidator < BaseValidatorMixin
      validations do
        required(:password).filled(:str?)
        required(:email).filled(:str?, :email?)
      end
    end
  end
end