class RentRequest < ActiveRecord::Base
  attr_accessible :car_id, :confirm_drop_off_location, :drop_off_at, :drop_off_at_receipt, :drop_off_location, :email, :message, :name, :phone, :receipt_at, :receipt_location

  belongs_to :car

  def confirm!
    self.confirmed = true
    save
  end

end
