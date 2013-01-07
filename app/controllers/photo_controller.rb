class PhotoController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    photo = current_user.photos.create :image => params[:file]
    render json: {url: photo.image_url}
  end
end
