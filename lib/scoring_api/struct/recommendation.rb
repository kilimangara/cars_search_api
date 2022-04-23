# frozen_string_literal: true

module ScoringAPI
  module Struct
    class Recommendation < Base
      attribute :car_id, Types::Strict::Integer
      attribute :rank_score, Types::Strict::Float
    end
  end
end
