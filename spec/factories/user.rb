# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'example@example.ru' }
    preferred_price_range { 10_000...35_000 }
    preferred_brands { [] }
  end
end
