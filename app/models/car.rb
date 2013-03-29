class Car < ActiveRecord::Base
  attr_accessible :conditioner, :engine, :minimum_reserve, :number_of_doors, :number_of_passengers, :transmission, :name, :manufacturer, :photo, :leather

  mount_uploader :photo, PhotoUploader

  validates :engine, presence: true, numericality: true
  validates :name, presence: true
  validates :manufacturer, presence: true

  has_one :rent
  has_one :driving_service
  has_one :special_rent
  has_many :rent_requests


  def full_name
    [ manufacturer, name, I18n.t('cars.transmissions.short.' + transmission) ].join(' ')
  end

  def transmission(given_value = nil)
    case given_value || read_attribute(:transmission)
    when 0 then 'manual'
    when 1 then 'auto'
    end
  end

  def transmission_selection_options
    [ 0, 1 ].map  { |type| [ I18n.t('cars.transmissions.' + transmission(type)), type ] }
  end

  def minimum_reserve
    2
  end

end
