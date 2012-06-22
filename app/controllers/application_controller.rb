class ApplicationController < ActionController::Base
  protect_from_forgery
  clear_helpers

  before_filter :set_locale

  def to_russian
    cookies[:locale] = :ru
    redirect_to :back
  end

  def to_english
    cookies[:locale] = :en
    redirect_to :back
  end

  private

  def set_locale
    I18n.locale = cookies[:locale].to_sym if cookies[:locale] and %w( ru en ).include?(cookies[:locale])
  end

end
