class WelcomeController < ApplicationController

  def index
    @cars = Car.joins(:rent).includes(:rent)
    @ads = Ad.all
    @rent_request = RentRequest.new
  end

  def about_us
  end

end
