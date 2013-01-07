class PhotoController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    photo = current_user.photos.create :image => params[:file]
    render text: photo.image_url
  end
end
