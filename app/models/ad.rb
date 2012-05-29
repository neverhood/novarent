class Ad < ActiveRecord::Base
  attr_accessible :body, :photo

  mount_uploader :photo, OfferUploader
end
