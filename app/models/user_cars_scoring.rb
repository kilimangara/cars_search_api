# frozen_string_literal: true

class UserCarsScoring < ApplicationRecord
  belongs_to :user
  belongs_to :car
end
