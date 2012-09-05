class RentsController < ApplicationController

  before_filter :authenticate!, except: :index
  before_filter :find_car!, except: :index

  respond_to :html

  def index
    @cars = Car.joins(:rent).includes(:rent)
  end

  def new
    @rent = @car.build_rent
  end

  def edit
    @rent = @car.rent
  end

  def update
    @rent = @car.rent.update_attributes(params[:rent])

    respond_with @car
  end

  def create
    @rent = @car.create_rent(params[:rent])

    respond_with @car
  end

  def destroy
    @rent = @car.rent
    @rent.destroy

    redirect_to car_path(@car)
  end

  private

  def find_car!
    @car = Car.where(id: params[:car_id] || params[:rent][:car_id]).first
    redirect_to root_path, notice: "not found" if @car.nil?
  end

end
