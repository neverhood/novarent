class RentRequestsController < ApplicationController
  http_basic_authenticate_with :name => ENV['DEN_LOGIN'], :password => ENV['DEN_PASSWORD'], :only => [ :destroy, :index ]

  before_filter :find_car!, except: [ :show, :update, :confirm ]
  before_filter :find_rent_request!, only: [ :destroy, :update ]

  respond_to :html

  def create
    @rent_request = @car.rent_requests.create(params[:rent_request])

    if @rent_request.valid?
      session[:request_id] = @rent_request.id
      redirect_to confirm_rent_request_path(@rent_request)
    else
      redirect_to root_path
    end
  end

  def confirm
    @rent_request = RentRequest.where(id: session[:request_id], confirmed: false).first
    @cars = Car.joins(:rent).includes(:rent)

    redirect_to root_path if @rent_request.nil?
  end

  def update
    if @rent_request.update_attributes params[:rent_request]
      respond_with @rent_request
    else
      @cars = Car.joins(:rent).includes(:rent)
      render 'confirm'
    end
  end

  def show
    @rent_request = RentRequest.where(id: session[:request_id], confirmed: true).first

    redirect_to root_path if @rent_request.nil?
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
