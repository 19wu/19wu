class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :bio, :name, :phone, :website
end
