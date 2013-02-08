class HomeController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def content_preview
    render :nothing => true, :status => 200,
           :json => {:result => ContentFilter.refine(params[:content]) }
  end

end
