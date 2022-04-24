# frozen_string_literal: true

module CarsSearchAPI
  module V1
    module Search
      extend ActiveSupport::Concern

      included do
        resource :cars do
          params do
            use :pagination
            requires :user_id, type: Integer, desc: 'ID пользователя'
            optional :price_min, type: Integer, desc: 'Фильтр минимальной цены'
            optional :price_max, type: Integer, desc: 'Фильтр максимальной цены'
            optional :query, type: String, desc: 'Поисковый фильтр(по названию брэндов)'
          end
          desc 'Отдает список рекомендаций для пользователя' do
            is_array true
            success Entity::Car
            failure [[404, 'not found', 'CommonAPIUtils::Entity::Error']]
          end
          get '' do
            user = User.find(params[:user_id])
            CacheUserRecommendationsService.new(user).cache_in_runtime
            query = UserCarsQuery.new(user, permitted_params.except(:user_id)).apply
            write_pagination_info(query)
            present query, with: Entity::Car
          end
        end
      end
    end
  end
end
