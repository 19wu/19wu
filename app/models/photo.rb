class Photo < ActiveRecord::Base
  attr_accessible :image, :user_id
  mount_uploader :image, PhotoUploader
end
