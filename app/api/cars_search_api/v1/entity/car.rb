# frozen_string_literal: true

module CarsSearchAPI
  module V1
    module Entity
      class Car < ::Grape::Entity
        expose :id
        expose :brand, with: Brand
        expose :model, documentation: { type: 'string', desc: 'Название модели', required: true }
        expose :price, documentation: { type: 'integer', desc: 'Цена', required: true }
        expose :rank_score, documentation: { type: 'float', desc: 'Скоринг рекомендации', required: false }
        expose :label, documentation: { type: 'string', desc: 'Оценка', values: ['perfect_match', 'good_match', nil] }

        def label
          case object.label_score
          when UserCarsQuery::GOOD_MATCH
            'good_match'
          when UserCarsQuery::PERFECT_MATCH
            'perfect_match'
          end
        end
      end
    end
  end
end
