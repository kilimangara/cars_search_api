# frozen_string_literal: true

module CarsSearchAPI
  module ErrorsHandler
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: e.message.to_s.gsub(/\[[\W\w]*/, '').strip}, 404)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ error: e.message }, 422)
      end

      rescue_from :all do |e|
        raise e if Rails.env.development? || Rails.env.test?

        Rails.logger.error "[#{e.class}] #{e.message}\n#{e.backtrace.join("\n")}"
        error!({ error: 'Internal server error', with: API::Error }, 500)
      end
    end
  end
end
