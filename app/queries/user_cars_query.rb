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

    query.select(sanitized_sql_select)
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

    @query = query.where("brands.name ilike '%?%'", params[:query])
  end

  private

  def sanitized_sql_select
    sql = <<~SQL
      cars.*,
      CASE
        WHEN brands.name in (:brands) AND cars.price in (:prices) THEN 2
        WHEN brands.name in (:brands) THEN 1
        ELSE 0
      END as label_score
    SQL

    ActiveRecord::Base.sanitize_sql_array(
      [
        sql,
        {
          brands: preferred_brand_names,
          prices: [user.preferred_price_range.first, user.preferred_price_range.last]
        }
      ]
    )
  end

  def preferred_brand_names
    @preferred_brand_names ||= user.preferred_brands.pluck(:name)
  end

  def query
    @query ||= Car.joins(:brand).paginate(page: params[:page], per_page: params[:per_page])
  end
end
