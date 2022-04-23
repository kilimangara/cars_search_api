# frozen_string_literal: true

module ScoringAPI
  module Methods
    module Recommendations
      def recommended_cars(user_id)
        raw_response = get('recomended_cars.json', { user_id: user_id })
        ScoringAPI::Response.new(raw_response, ScoringAPI::Struct::Recommendation)
      end
    end
  end
end
