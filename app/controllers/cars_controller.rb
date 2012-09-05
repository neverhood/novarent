class CarsController < ApplicationController

  before_filter :authenticate!
  before_filter :find_car!, only: [ :show, :edit, :update, :destroy ]

  respond_to :html

  def index
    @cars = Car.all
  end

  def new
    @car = Car.new
  end

  def show
  end

  def edit
  end

  def update
    @car.update_attributes(params[:car])

    respond_with @car
  end

  def create
    @car = Car.create( params[:car] )

    respond_with @car
  end

  def destroy
    @car.destroy

    respond_with @car
  end

  private

  def find_car!
    @car = Car.where(id: params[:id]).first
    redirect_to root_path, notice: "not found" if @car.nil?
  end

end
