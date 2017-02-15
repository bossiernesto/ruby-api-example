require 'sidekiq'

config_redis = proc.new { |config| config.redis = {url: REDIS_URL} }

Sidekiq.configure_server &config_redis
Sidekiq.configure_client &config_redis
