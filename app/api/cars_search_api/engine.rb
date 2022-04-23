# frozen_string_literal: true

module CarsSearchAPI
  class Engine < Grape::API
    helpers CommonHelpers
    include ErrorsHandler

    mount V1::Root

    route :any, '*path' do
      error!('Not Found', 404)
    end
  end
end
