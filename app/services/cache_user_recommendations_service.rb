# frozen_string_literal: true

class CacheUserRecommendationsService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def write!(list)
    Rails.cache.write("users:#{user.id}:cars", ActiveSupport::JSON.encode(list), expires_in: seconds_until_expiration)
  end

  def read
    list_str = Rails.cache.read("users:#{user.id}:cars")
    return if list_str.blank?

    json = ActiveSupport::JSON.decode(list_str)
    json.map { |el| ScoringApi::Struct::Recommendation.new(el) }
  end

  def fetch
    list = read || ScoringApi::Client.new.recommended_cars(user.id)
    write!(list)
  end

  private

  def seconds_until_expiration
    # Time.zone.now.end_of_day as a time of reindexing recommendation app
    # We can place any value here

    time = (Time.zone.now.end_of_day - Time.zone.now).to_i
  end
end
