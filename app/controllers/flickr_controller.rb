class FlickrController < ApplicationController
  def index
    @photos = FlickrPhoto.order("uploaded DESC")
  end

  def update_location
    if admin
      photo = FlickrPhoto.find(params[:id])
      photo.lat = params[:latitude]
      photo.lon = params[:longitude]
      photo.save
    end
    render :text => photo.to_json
  end

  def display_large
    photo = FlickrPhoto.find(params[:id])
    render photo.url('l')
  end
end
