# frozen_string_literal: true

config = Rails.configuration.database_configuration['redis_default']

pool_size = config['pool']
REDIS_POOL = ConnectionPool.new(size: pool_size, timeout: 5) { Redis.new(config.except('pool')) }
