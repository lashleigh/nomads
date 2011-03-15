class FlickrController < ApplicationController
  layout 'posts'
  def index
    @photos = FlickrPhoto.find(:all).reverse
  end

  def update_location
    if @user.admin?
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
