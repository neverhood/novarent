class RentRequest < ActiveRecord::Base
  attr_accessible :car_id, :confirm_drop_off_location, :drop_off_at, :drop_off_at_receipt, :drop_off_location,
    :email, :message, :name, :phone, :receipt_at, :receipt_location, :confirmed, :has_gps, :has_child_seat, :has_additional_driver

  attr_accessor :skip_confirmation

  PRICES = { gps: 5, child_seat: 5, additional_driver: 5 }

  belongs_to :car
  has_one :rent, :through => :car

  before_create do
    self.drop_off_location = nil if self.confirm_drop_off_location? or self.drop_off_at_receipt?
  end

  validates :drop_off_at, presence: true
  validates :drop_off_location, presence: true, unless: lambda { self.confirm_drop_off_location? or self.drop_off_at_receipt? }
  validates :name, presence: true
  validates :receipt_at, presence: true
  validates :receipt_location, presence: true
  validates :email, presence: true
  validate :dates_range

  def total_cost
    return 0 if drop_off_at.nil? or receipt_at.nil?

    rent_cost + cost_of(:gps) + cost_of(:child_seat) + cost_of(:additional_driver)
  end

  def rent_cost
    total_days > 0 ? total_days * rent.send(stringified_period.to_sym) : 0
  end

  def cost_of item
    if self.send(:"has_#{item}?")
      total_days > 10 ? PRICES[item] * 10 : PRICES[item] * total_days
    else
      0
    end
  end

  def stringified_period
    days = total_days

    if days <= 0
      'invalid'
    elsif days < 3
      'one_to_two'
    elsif days < 6
      'three_to_five'
    elsif days < 13
      'six_to_twelve'
    elsif days < 25
      'thirteen_to_twenty_four'
    else
      'month'
    end
  end

  def total_days
    ( ( drop_off_at - receipt_at ) / (60*60*24) ).ceil
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

  private

  def dates_range
    self.errors[:drop_off_at] = "invalid" if drop_off_at.nil? or receipt_at.nil? or drop_off_at <= receipt_at
  end

end
