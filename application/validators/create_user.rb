class Api
  module Validators
    class CreateUserValidator < BaseValidatorMixin
      validations do
        required(:first_name).filled(:str?)
        required(:last_name).filled(:str?)
        required(:password).filled(:str?)
        required(:email).filled(:str?, :email?)

        optional(:born_on).maybe(:str?, :datetime_str?)
      end
    end
  end
end
