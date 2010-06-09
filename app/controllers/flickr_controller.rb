class FlickrController < ApplicationController
  layout "home"

  def index
    @photos = FlickrPhoto.find(:all)
  end

  def update_location
    photo = FlickrPhoto.find(params[:id])
    photo.lat = params[:latitude]
    photo.lon = params[:longitude]
    photo.save
    render :text => photo.to_json
  end

  def display_large
    photo = FlickrPhoto.find(params[:id])
    render photo.url('l')
  end

end
