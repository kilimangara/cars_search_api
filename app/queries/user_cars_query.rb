# frozen_string_literal: true

class UserCarsQuery
  attr_reader :user, :params

  def initialize(user, params)
    @user = user
    @params = params
  end

  def apply
    apply_min_price_filter
    apply_max_price_filter
    apply_car_brand_filter

    query
  end

  def apply_min_price_filter
    return if params[:min_price].blank?

    @query = query.where('cars.price >= ?', params[:min_price])
  end

  def apply_max_price_filter
    return if params[:max_price].blank?

    @query = query.where('cars.price <= ?', params[:max_price])
  end

  def apply_car_brand_filter
    return if params[:query].blank?

    @query = query.where("brands.name ilike ?", "%#{params[:query]}%")
  end

  private

  def sanitized_sql_select
    sql = <<~SQL
      cars.*,
      CASE
        WHEN brands.id in (:brands) AND cars.price > :min_price AND cars.price < :max_price THEN 2
        WHEN brands.id in (:brands) THEN 1
        ELSE 0
      END as label_score,
      user_cars_scorings.scoring as rank_score
    SQL

    ActiveRecord::Base.sanitize_sql_array(
      [
        sql,
        {
          brands: preferred_brand_ids,
          max_price: user.preferred_price_range.last,
          min_price: user.preferred_price_range.first
        }
      ]
    )
  end

  def preferred_brand_ids
    @preferred_brand_ids ||= user.preferred_brands.pluck(:id)
  end

  def query
    @query ||=
      Car.select(sanitized_sql_select)
         .joins(:brand)
         .includes(:brand)
         .joins("LEFT JOIN user_cars_scorings on cars.id = user_cars_scorings.car_id AND user_cars_scorings.user_id = #{user.id}")
         .paginate(page: params[:page], per_page: params[:per_page])
         .order('label_score DESC', 'rank_score DESC NULLS LAST', 'price ASC')
  end
end
