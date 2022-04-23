# frozen_string_literal: true

class CacheUserRecommendationsService
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    list = scoring_api.recommended_cars(user.id).struct
    # persist only top 5 recommendations
    list.sort_by! { |el| -el.rank_score }
    persist(list[0..4])
  end

  def actual?
    Rails.cache.read("user_cars_scoring:#{user.id}:actual").present?
  end

  private

  def persist(list)
    ActiveRecord::Base.transaction do
      UserCarsScoring.where(user_id: user.id).delete_all
      list.each do |item|
        # WTF scoring api sending repeated car_ids
        next if UserCarsScoring.exists?(user_id: user.id, car_id: item.car_id)

        UserCarsScoring.create!(
          user_id: user.id,
          scoring: item.rank_score,
          car_id: item.car_id
        )
      end
    end
  end

  def write_identity!
    Rails.cache.write("user_cars_scoring:#{user.id}:actual", 'true', expires_in: seconds_until_expiration)
  end

  def seconds_until_expiration
    # Time.zone.now.end_of_day as a time of reindexing recommendation app
    # We can place any value here

    (Time.zone.now.end_of_day - Time.zone.now).to_i
  end

  def scoring_api
    @scoring_api ||= ScoringAPI::Client.new
  end
end
