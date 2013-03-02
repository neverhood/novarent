class GlobalNotificationsController < ApplicationController
  before_filter :authenticate!

  before_filter :find_global_notification!, only: [ :activate, :update, :destroy, :edit ]

  def index
    @global_notifications = GlobalNotification.page(params[:page])
  end

  def new
    @global_notification = GlobalNotification.new
  end

  def create
    @global_notification = GlobalNotification.create(params[:global_notification])

    redirect_to global_notifications_path
  end

  def destroy
    @global_notification.destroy

    redirect_to global_notifications_path
  end

  def edit
  end

  def update
    @global_notification.update_attributes params[:global_notification]

    redirect_to global_notifications_path
  end

  def activate
    @global_notification.activate!

    redirect_to global_notifications_path
  end

  private

  def find_global_notification!
    @global_notification = GlobalNotification.where(id: params[:id]).first

    redirect_to root_path, notice: "not found" if @global_notification.nil?
  end
end
