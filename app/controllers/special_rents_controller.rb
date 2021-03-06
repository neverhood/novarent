class SpecialRentsController < ApplicationController

  before_filter :authenticate!, except: :index
  before_filter :find_car!, except: :index

  respond_to :html

  def index
    @cars = Car.joins(:special_rent).includes(:special_rent).ordered_by_position
  end

  def new
    @special_rent = @car.build_special_rent
  end

  def edit
    @special_rent = @car.special_rent
  end

  def update
    @special_rent = @car.special_rent.update_attributes(params[:special_rent])

    respond_with @car
  end

  def create
    @special_rent = @car.create_special_rent(params[:special_rent])

    respond_with @car
  end

  def destroy
    @special_rent = @car.special_rent
    @special_rent.destroy

    redirect_to car_path(@car)
  end

  private

  def find_car!
    @car = Car.where(id: params[:car_id] || params[:special_rent][:car_id]).first
    redirect_to root_path, notice: "not found" if @car.nil?
  end

end
