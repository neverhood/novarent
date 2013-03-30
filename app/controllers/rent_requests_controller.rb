class RentRequestsController < ApplicationController

  before_filter :authenticate!, only: [ :destroy, :index, :show ]
  before_filter :find_car!, except: [ :show, :update, :create, :new ]
  before_filter :find_rent_request!, only: [ :destroy, :update, :show ]

  respond_to :html

  def index
    @rent_requests = RentRequest.all
  end

  def new
    session.delete(:rent_request_params) if params[:car_id]
    session[:request_type] = 'rent' if params[:rent_request]

    if params[:type] and session[:request_type] != params[:type]
      session[:request_type] = %(rent special_rent driving_service).include?(params[:type]) ? params[:type] : 'rent'
    end

    if session[:rent_request_params] or params[:rent_request]
      session[:rent_request_params] = params[:rent_request] if params[:rent_request]

      @car = Car.where(id: session[:rent_request_params][:car_id]).first
      @rent_request = @car.rent_requests.new(session[:rent_request_params])

      session[:car_id] = @car.id unless @car.nil?
    else
      @car = Car.where(id: params[:car_id] || session[:car_id]).first
      @rent_request = @car.rent_requests.new unless @car.nil?

      session[:car_id] = @car.id unless @car.nil?
    end

    redirect_to root_path if @car.nil? or @rent_request.nil?

    @request_type = session[:request_type].inquiry
    @cars = Car.joins(:rent).includes(:rent)

    @rent = @car.rent if @request_type.rent?
    @driving_service = @car.driving_service if @request_type.driving_service?
    @special_rent = @car.special_rent if @request_type.special_rent?
  end

  def create
    @car = Car.where(id: session[:car_id]).first

    if @car.nil? or not ['rent', 'driving_service', 'special_rent'].include?(session[:request_type])
      redirect_to root_path and return
    end

    @request_type = session[:request_type].inquiry
    @rent_request = @car.rent_requests.build(params[:rent_request])
    @rent_request.request_type = RentRequest::REQUEST_TYPES[@request_type.to_sym]

    if @rent_request.valid?
      @rent_request.save

      session.delete(:rent_request_params)
      session.delete(:request_type)
      session.delete(:car_id)

      RentRequestsMailer.owner(@rent_request).deliver
      RentRequestsMailer.client(@rent_request).deliver

      render 'show'
      #redirect_to rent_request_path(@rent_request)
    else
      @rent = @car.rent if @request_type.rent?
      @driving_service = @car.driving_service if @request_type.driving_service?
      @special_rent = @car.special_rent if @request_type.special_rent?

      render 'new'
    end
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
