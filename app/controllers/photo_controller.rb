class PhotoController < ApplicationController
  before_filter :authenticate_user!

  def create
    files = params[:files].map do |file|
      photo = current_user.photos.create :image => file
      image_url = photo.image_url
      image_name = File.basename(image_url, File.extname(image_url))
      { :name => image_name, :url =>  photo.image_url(:normal) }
    end
    render json: {files: files}
  end
end
