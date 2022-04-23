# frozen_string_literal: true

module CarsSearchAPI
  module V1
    class Root < ::Grape::API
      version 'v1'
      prefix :search
      format :json
      helpers CarsSearchAPI::CommonHelpers

      include Search
      add_swagger_documentation hide_documentation_path: true,
                                api_version: 'v1',
                                info: {
                                  title: 'Horses and Hussars',
                                  description: 'Demo app for dev of grape swagger 2.0'
                                }
    end
  end
end
