class SpecialRent < ActiveRecord::Base
  attr_accessible :thursday_to_monday, :friday_to_monday, :thursday_to_tuesday, :car_id

  belongs_to :car
end
