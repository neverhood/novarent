class WelcomeController < ApplicationController

  def index
    @cars = Car.joins(:rent).includes(:rent).ordered_by_position
    @ads = Ad.all
    @global_notifications = GlobalNotification.recent
    @rent_request = RentRequest.new
  end

  def about_us
  end

  def partners
  end

  def to_partners
  end

end
