# frozen_string_literal: true

module CarsSearchAPI
  module V1
    module Entity
      class Brand < Grape::Entity
        expose :id
        expose :name
      end
    end
  end
end
