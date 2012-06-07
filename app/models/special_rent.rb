class SpecialRent < ActiveRecord::Base
  attr_accessible :car_id, :friday_to_monday, :friday_to_tuesday, :thursday_to_monday

  belongs_to :car
end
