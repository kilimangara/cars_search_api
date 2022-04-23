# frozen_string_literal: true

class CacheUserRecommendationsJob < ActiveJob::Base
  queue_as :low
  def perform(user_ids)
    users = User.where(id: user_ids)

    failed_ids = []
    users.each do |user|
      result = client.recommended_cars(user.id)

      # Write cache no matter if it exists
      CacheUserRecommendationsService.new(user).write!(result)
    rescue ScoringApi::Exceptions::Base
      failed_ids.push(user.id)
    end

    requeue_failed(failed_ids) if failed_ids.present?
  end

  private

  def requeue_failed(ids)
    return if executions > 5

    self.arguments = [ids]
    wait = determine_delay(seconds_or_duration_or_algorithm: :exponentially_longer, executions: executions)
    retry_job(wait: wait)
  end

  def client
    @client ||= ScoringApi::Client.new
  end
end
