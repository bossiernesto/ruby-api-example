class Api
  module Entities
    class User < Grape::Entity
      format_with(:iso_date) { |date|
        date.to_date.iso8601
      }

      format_with(:iso_timestamp) { |date|
        date.iso8601
      }

      expose :id, documentation: {type: 'Integer', desc: "User ID"}
      expose :first_name, documentation: {type: 'String', desc: "User's first name"}
      expose :last_name, documentation: {type: 'String', desc: "User's last name"}
      expose :email, documentation: {type: 'String', desc: "User's email name"}

      with_options(format_with: :iso_date) do
        expose :born_on, documentation: {type: "dateTime", desc: "User's birthday date"}
      end

      with_options(format_with: :iso_timestamp) do
        expose :created_at, documentation: {type: 'Timestamp', desc: "User's creation timestamp"}
        expose :updated_at, documentation: {type: 'Timestamp', desc: "User's last update timestamp"}
      end
    end
  end
end
