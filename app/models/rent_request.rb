class RentRequest < ActiveRecord::Base
  attr_accessible :car_id, :confirm_drop_off_location, :drop_off_at, :drop_off_at_receipt, :drop_off_location,
    :email, :message, :name, :phone, :receipt_at, :receipt_location, :confirmed, :has_gps, :has_child_seat, :has_additional_driver,
    :driving_service, :number_of_babe_seats, :number_of_child_seats, :special_time_period

  attr_accessor :skip_confirmation

  PRICES = { gps: 5, child_seat: 5, additional_driver: 5 }
  CITY_DELIVERY_PRICE = 25
  REQUEST_TYPES = { rent: 0, driving_service: 1, special_rent: 2 }

  belongs_to :car
  has_one :rent, :through => :car

  before_create do
    self.drop_off_location = nil if self.confirm_drop_off_location? or self.drop_off_at_receipt?
  end

  validates :drop_off_at, presence: true, unless: lambda { request_type.driving_service? and driving_service.transfer? }
  validates :drop_off_location, presence: true, unless: lambda { self.confirm_drop_off_location? or self.drop_off_at_receipt? }
  validates :name, presence: true
  validates :receipt_at, presence: true
  validates :receipt_location, presence: true
  validates :email, presence: true
  validate :dates_range

  def total
    return 0 if drop_off_at.nil? or receipt_at.nil?

    if request_type.nil? or request_type.rent?
      rent_cost + cost_of(:gps) + cost_of(:child_seat) + cost_of(:additional_driver) + delivery_cost + return_cost
    elsif request_type.special_rent?
      car.special_rent.send( special_time_period.to_sym ) + delivery_cost + return_cost
    end
  end

  def has_additional_services?
    has_gps? or has_additional_driver? or has_child_seat?
  end

  def delivery_cost
    #I18n.t('rent_requests.locations').include?(receipt_location) ? 0 : CITY_DELIVERY_PRICE
    CITY_DELIVERY_PRICE
  end

  def return_cost
    CITY_DELIVERY_PRICE
    #if drop_off_at_receipt?
      #delivery_cost
    #elsif confirm_drop_off_location?
      #CITY_DELIVERY_PRICE
    #else
      #I18n.t('rent_requests.locations').include?(drop_off_location) ? 0 : CITY_DELIVERY_PRICE
    #end
  end

  def rent_cost
    total_days > 0 ? total_days * rent.send(stringified_period.to_sym) : 0
  end

  def cost_of item
    if self.send(:"has_#{item}?")
      if item == :child_seat
        price = ( self.number_of_babe_seats + self.number_of_child_seats ) * total_days * PRICES[item]
        price > 50 ? 50 : price
      else
        total_days > 10 ? PRICES[item] * 10 : PRICES[item] * total_days
      end
    else
      0
    end
  end

  def cost_of_babe_seats
    price = number_of_babe_seats * total_days * PRICES[:child_seat]
    price > 50 ? 50 : price
  end

  def cost_of_child_seats
    price = number_of_child_seats * total_days * PRICES[:child_seat]
    price > 50 ? 50 : price
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
    return 0 if drop_off_at.nil? or receipt_at.nil?

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

  def special_time_period(given_value = nil)
    case given_value || read_attribute(:special_time_period)
    when 0 then 'friday_to_monday'
    when 1 then 'thursday_to_monday'
    when 2 then 'friday_to_tuesday'
    end
  end

  def driving_service(given_value = nil)
    case given_value || read_attribute(:driving_service)
    when 0 then 'hourly'.inquiry
    when 1 then 'transfer'.inquiry
    end
  end

  def request_type(given_value = nil)
    case given_value || read_attribute(:request_type)
    when 0 then 'rent'.inquiry
    when 1 then 'driving_service'.inquiry
    when 2 then 'special_rent'.inquiry
    end
  end

  def special_rents_selection_options
    [0, 1, 2].map { |value| [ I18n.t('rent_requests.special_time_periods.' + special_time_period(value)), value ] }
  end

  def driving_services_selection_options
    [0, 1].map { |value| [ I18n.t('rent_requests.driving_services.' + driving_service(value)), value ] }
  end

  def child_seats_count
    ( self.number_of_babe_seats || 0 ) + ( self.number_of_child_seats || 0 )
  end

  private

  def dates_range
    unless request_type.driving_service? and driving_service.transfer?
      self.errors[:drop_off_at] = "invalid" if drop_off_at.nil? or receipt_at.nil? or drop_off_at <= receipt_at
    end
  end
end
