# frozen_string_literal: true

module ScoringApi
  module Methods
    module Recommendations
      def recommended_cars(user_id)
        get('recomended_cars.json', { user_id: user_id })
      end
    end
  end
end
