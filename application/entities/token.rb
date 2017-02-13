class Api
  module Entities
    class Token < Grape::Entity
      expose :token, documentation: { type: 'String', desc: 'User Authentication token' }
    end
  end
end
