class Api
  module Exceptions

    class ApiBaseError < StandardError
      attr_accessor :errors

      def initialize(msg, errors={})
        self.errors = errors
        super msg
      end

    end

    class UserNotFound < ApiBaseError
      def initialize(msg='User not Found', errors={})
        super msg, errors
      end

    end

    class ValidationError < ApiBaseError
      def initialize(msg='Validation Errors', errors={})
        super msg, errors
      end

    end

    class UnauthorizedUser < ApiBaseError
      def initialize(msg='Unauthorized User', errors={})
        super msg, errors
      end

    end

    class CantEditUser < ApiBaseError
      def initialize(msg='Unauthorized User', errors={})
        super msg, errors
      end
    end
  end
end