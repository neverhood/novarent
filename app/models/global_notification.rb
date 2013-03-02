class GlobalNotification < ActiveRecord::Base

  attr_accessible :active, :text, :english_text

  def self.current
    where(active: true).first
  end

  def self.recent amount = 5
    unscoped.order('global_notifications.created_at DESC').limit(amount)
  end

  default_scope -> { order('global_notifications.active DESC, global_notifications.id DESC') }

  def activate!
    self.class.where(active: true).update_all(active: false)

    update_attributes(active: true)
  end

end
