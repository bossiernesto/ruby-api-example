require 'lib/abilities'

class Api
  module Models
    class User < Sequel::Model(:users)
      include AbilityList::Helpers
      plugin :secure_password, include_validations: false

      def abilities
        @abilities ||= Abilities.new(self)
      end

      def full_name
        "#{self.first_name} #{self.last_name}"
      end
    end
  end
end
