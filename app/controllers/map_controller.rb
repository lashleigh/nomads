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
    @suggestions = Suggestion.find(:all).collect do |s|
      { "id" => s.id,
        "name" => s.name,
        "latitude" => s.lat,
        "longitude" => s.lon,
        "suggestion_type" => s.suggestion_type,
        "content" => s.content }
    end
  end

  def show_suggestions
    @suggestions = Suggestion.all.reverse
  end

  # For rendering in a fancybox
  def new_suggestion
    @suggestion = Suggestion.new
    @suggestion.lat = params[:lat]
    @suggestion.lon = params[:lng]
    unless @suggestion.lat and @suggestion.lon
      render :text => "<h3>Please provide the coordinates of your suggestion.</h3>"
    else
      render :layout => false
    end
  end
end
