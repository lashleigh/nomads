class MapController < ApplicationController
  before_filter :set_icons

  def index
    @posts = Post.find(:all).collect { |p| p.as_hash }
    @photos = FlickrPhoto.find(:all, :order => "id ASC", :limit => 5).collect { |p| p.as_hash }
    @suggestions = Suggestion.find(:all).collect { |s| s.as_hash }
  end

  # For rendering in a fancybox
  def new_suggestion
    @suggestion = Suggestion.new
    @suggestion.lat = params[:lat]
    @suggestion.lon = params[:lng]
    @suggestion.title = params[:title]
    @suggestion.icon_id = params[:icon_id]
    unless @suggestion.lat and @suggestion.lon
      render :text => "<h3>Please provide the coordinates of your suggestion.</h3>"
    else
      render :layout => false
    end
  end

  private
  def set_icons
    @icons = Icon.all
  end
end
