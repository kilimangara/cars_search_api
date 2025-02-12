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
                                doc_version: '0.0.1',
                                info: {
                                  title: 'Cars Search API',
                                  description: 'Cars recommendation search API'
                                }
    end
  end
end
