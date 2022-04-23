# frozen_string_literal: true

module ScoringApi
  module Methods
    module Recommendations
      def recommended_cars(user_id)
        raw_response = get('recomended_cars.json', { user_id: user_id })
        ScoringApi::Response.new(raw_response, ScoringApi::Struct::Recommendation)
      end
    end
  end
end
