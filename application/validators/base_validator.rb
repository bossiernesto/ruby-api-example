class Api
  module Validators
    class BaseValidatorMixin
      include Hanami::Validations::Form
      predicates FormPredicates
    end
  end
end