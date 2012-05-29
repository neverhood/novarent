class WelcomeController < ApplicationController

  def index
    @cars = Car.joins(:rent).includes(:rent)
    @ads = Ad.all
  end

  def about_us
  end

end
