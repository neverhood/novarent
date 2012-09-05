class DrivingServicesController < ApplicationController

  before_filter :authenticate!, except: [ :index ]
  before_filter :find_car!, except: [ :index ]

  respond_to :html

  def index
    @cars = Car.joins(:driving_service).includes(:driving_service)
  end

  def new
    @driving_service = @car.build_driving_service
  end

  def edit
    @driving_service = @car.driving_service
  end

  def update
    @driving_service = @car.driving_service.update_attributes(params[:driving_service])

    respond_with @car
  end

  def create
    @driving_service = @car.create_driving_service(params[:driving_service])

    respond_with @car
  end

  def destroy
    @driving_service = @car.driving_service
    @driving_service.destroy

    redirect_to car_path(@car)
  end

  private

  def find_car!
    @car = Car.where(id: params[:car_id] || params[:driving_service][:car_id]).first
    redirect_to root_path, notice: "not found" if @car.nil?
  end

end
