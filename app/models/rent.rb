class Rent < ActiveRecord::Base
  attr_accessible :bail, :day, :car_id, :month, :one_to_two, :six_to_twelve, :thirteen_to_twenty_four, :three_to_five

  validates :bail, presence: true
  validates :day, presence: true
  validates :one_to_two, presence: true
  validates :three_to_five, presence: true
  validates :six_to_twelve, presence: true
  validates :thirteen_to_twenty_four, presence: true
  validates :month, presence: true

  belongs_to :car
end
