# frozen_string_literal: true

module CarsSearchAPI
  module V1
    module Search
      extend ActiveSupport::Concern

      included do
        resource :cars do
          params do
            use :pagination
            requires :user_id, type: Integer
            optional :price_min, type: Integer
            optional :price_max, type: Integer
            optional :query, type: String
          end
          get '' do
            user = User.find(params[:user_id])
            query = UserCarsQuery.new(user, permitted_params.except(:user_id)).apply
            present query, with: Entity::Car
          end
        end
      end
    end
  end
end
