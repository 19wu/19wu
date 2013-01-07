class PhotoController < ApplicationController
  prepend_before_filter :authenticate_user!

  def create
    files = params[:files].map do |file|
      photo = current_user.photos.create :image => file
      {'url' =>  photo.image_url}
    end
    render json: {files: files}
  end
end
