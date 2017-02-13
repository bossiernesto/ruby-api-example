class Api
  module Exceptions

    class UserNotFound < StandardError

    end

    class ValidationError < StandardError

      attr_accessor :validation_errors

      def initialize(msg, validation_errors={})
        self.validation_errors = validation_errors
        super msg
      end

    end

    class UnauthorizedUser < StandardError

    end

    class CantEditUser < StandardError

    end
  end
end