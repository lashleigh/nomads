class MapController < ApplicationController
  layout "home"
  def index
    @photos = FlickrPhoto.find(:all, :order => "id ASC", :limit => 5).collect do |p|
      { "id" => p.id,
        "url" => p.url,
        "latitude" => p.lat,
        "longitude" => p.lon,
        "title" => p.title }
    end
  end

end
