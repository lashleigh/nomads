class MapController < ApplicationController
  before_filter :set_icons

  def index
    @posts = Post.find(:all).collect { |p| p.as_hash }
    @photos = FlickrPhoto.find(:all).collect { |p| p.as_hash }
    @suggestions = Suggestion.find(:all).collect { |s| s.as_hash }
    @waypoints = Waypoint.full_track_points
    render :layout => false
  end

  # For rendering in a fancybox
  def new_suggestion
    @suggestion = Suggestion.new
    @suggestion.lat = params[:lat]
    @suggestion.lon = params[:lng]
    @suggestion.title = params[:title]
    @suggestion.icon_id = params[:icon_id]

    if not @suggestion.lat and @suggestion.lon
      render :text => "<h3>Please provide the coordinates of your suggestion.</h3>"
    elsif not @user
      render :text => "<h3>You must be logged in to make a suggestion.</h3>"
    else
      render :layout => false
    end
  end

  def waypoints
    @waypoints = Waypoint.full_track
    @suggestions = Suggestion.all
  end

  private
  def set_icons
    @icons = Icon.all
  end
end
