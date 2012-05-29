class WelcomeController < ApplicationController

  def index
    @cars = Car.joins(:rent).includes(:rent)
  end

  def about_us
  end

end
