require 'mail'

if RACK_ENV == 'test'

  Mail.defaults do
    delivery_method :test
  end

else

  mail_uri = URI.parse MAIL_URL

  Mail.defaults do
    delivery_method mail_uri.scheme, address: mail_uri.host, port: mail_uri.port
  end

end
