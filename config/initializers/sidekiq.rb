# frozen_string_literal: true

redis_config = Rails.configuration.database_configuration['redis_default']

Sidekiq.configure_server do |config|
  config.redis = redis_config
end

Sidekiq.configure_client do |config|
  config.redis = redis_config
end
