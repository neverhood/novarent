class RentRequestsController < ApplicationController
  http_basic_authenticate_with :name => ENV['DEN_LOGIN'], :password => ENV['DEN_PASSWORD'], :only => [ :destroy, :index ]

  before_filter :find_car!
  before_filter :find_rent_request!, only: [ :destroy, :edit, :show, :update ]

  respond_to :html

  def create
    @rent_request = @car.rent_requests.create(params[:rent_request])

    respond_with @rent_request
  end

  def edit
  end

  def update
    @rent_request.update_attributes params[:rent_request]
    @rent_request.car_id = @car.id
    @rent_request.save

    respond_with @rent_request
  end

  def show
  end

  def destroy
    @rent_request.destroy

    redirect_to :index
  end

  private

  def find_car!
    @car = Car.where(id: params[:car_id] || params[:rent_request].delete(:car_id)).first
    redirect_to root_path if @car.nil?
  end

  def find_rent_request!
    @rent_request = RentRequest.where(id: params[:id]).first
    redirect_to root_path if @rent_request.nil?
  end

end
