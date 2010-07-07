class MapController < ApplicationController
  layout "home"
  def index
    display_icons
    @photos = FlickrPhoto.find(:all, :order => "id ASC", :limit => 5).collect do |p|
      { "id" => p.id,
        "url" => p.url,
        "latitude" => p.lat,
        "longitude" => p.lon,
        "title" => p.title }
    end
    @suggestions = Suggestion.find(:all).collect do |s|
      { "id" => s.id,
        "name" => s.name,
        "latitude" => s.lat,
        "longitude" => s.lon,
        "icon_path" => s.icon.marker_url,
        "content" => s.content }
    end
  end

  # For rendering in a fancybox
  def new_suggestion
    display_icons
    @suggestion = Suggestion.new
    @suggestion.lat = params[:lat]
    @suggestion.lon = params[:lng]
    @suggestion.name = params[:name]
    @suggestion.icon_id = params[:icon_id]
    unless @suggestion.lat and @suggestion.lon
      render :text => "<h3>Please provide the coordinates of your suggestion.</h3>"
    else
      render :layout => false
    end
  end

  private
  def display_icons
    @icons = Icon.all
  end
end
