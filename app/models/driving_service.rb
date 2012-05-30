class DrivingService < ActiveRecord::Base
  attr_accessible :car_id, :cost, :mileage, :one_hour, :transfer

  belongs_to :car

  validates :cost, presence: true
  validates :mileage, presence: true
  validates :one_hour, presence: true
  validates :transfer, presence: true
end
