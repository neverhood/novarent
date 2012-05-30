class RentRequest < ActiveRecord::Base
  attr_accessible :car_id, :confirm_drop_off_location, :drop_off_at, :drop_off_at_receipt, :drop_off_location, :email, :message, :name, :phone, :receipt_at, :receipt_location, :confirmed

  belongs_to :car

  before_create do
    self.drop_off_location = nil if self.confirm_drop_off_location? or self.drop_off_at_receipt?
  end

  validates :drop_off_at, presence: true
  validates :drop_off_location, presence: true, unless: lambda { self.confirm_drop_off_location? or self.drop_off_at_receipt? }
  validates :name, presence: true
  validates :receipt_at, presence: true
  validates :receipt_location, presence: true
  validates :email, presence: true

  def confirm!
    self.confirmed = true
    save
  end

  def stringified_drop_off_location
    if drop_off_at_receipt?
      receipt_location
    elsif confirm_drop_off_location?
      I18n.t('activerecord.attributes.rent_request.confirm_drop_off_location')
    else
      drop_off_location
    end
  end

end
