class MapController < ApplicationController
  before_filter :set_icons
  layout 'map'

  def index
    @posts = Post.published.order("created_at DESC")
    @photos = FlickrPhoto.all
    @sug_hash = {} 
    Icon.all.each do |icon| 
      @sug_hash[icon.name] = Suggestion.where("icon_id=?", icon.id).collect{ |p| p.serializable_hash(:include => [:user])}
    end
    @waypoints = Waypoint.full_track_points
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

  private
  def set_icons
    @icons = Icon.where("name !=?", "blog").where("name !=?", "image")
  end
end
