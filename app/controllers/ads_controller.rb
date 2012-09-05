class AdsController < ApplicationController

  respond_to :html

  before_filter :authenticate!
  before_filter :find_ad!, only: [ :show, :edit, :update, :destroy ]

  def index
    @ads = Ad.all
  end

  def new
    @ad = Ad.new
  end

  def create
    @ad = Ad.create params[:ad]

    respond_with @ad
  end

  def edit
  end

  def show
  end

  def update
    @ad.update_attributes( params[:ad] )

    respond_with @ad
  end

  def destroy
    @ad.destroy

    respond_with @ad
  end

  private

  def find_ad!
    @ad = Ad.where(id: params[:id]).first
    redirect_to root_path, notice: 'not found' if @ad.nil?
  end

end
