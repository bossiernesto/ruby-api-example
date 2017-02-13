class Api
  module Validators
    class LoginUserValidator < BaseValidatorMixin
      required(:password).filled(:str?)
      required(:email).filled(:str?, :email?)
    end
  end
end