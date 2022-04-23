# frozen_string_literal: true

class MixSuggestedCarsService
  attr_reader :user, :query

  def initialize(user, query)
    @user = user
    @query = query
  end

  def call
    top_suggestions = cache_service.fetch.sort_by { |el| [-el.rank_score] }[..4]
  end

  private

  def cache_service
    @cache_service ||= CacheUserRecommendationsService.new(user)
  end
end
