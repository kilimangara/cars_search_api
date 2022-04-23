# frozen_string_literal: true

module CarsSearchAPI
  module V1
    module Entity
      class Car < ::Grape::Entity
        expose :id
        expose :brand, with: Brand
        expose :model
        expose :price
        expose :rank_score
        expose :label

        def label
          case object.label_score
          when 1
            'good_match'
          when 2
            'perfect_match'
          end
        end
      end
    end
  end
end
