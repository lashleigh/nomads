class WaypointsController < ApplicationController
  before_filter :must_be_admin

  def index
    @waypoints = Waypoint.full_track
    @waypoint_track = Waypoint.full_track_points
    @positions = Post.all + Suggestion.all - @waypoints.collect { |w| w.position }
  end

  def new
    @waypoint = Waypoint.new
    @waypoint.position_id = params[:position_as_string].split("_")[1] 
    @waypoint.position_type = params[:position_as_string].split("_")[0].capitalize
    if params[:prev_waypoint_as_string] != "false"
      @waypoint.prev_waypoint_id = params[:prev_waypoint_as_string].split("_")[1] 
    end
    @waypoint.save

    if params[:next_waypoint_as_string] != "false"
      next_id = params[:next_waypoint_as_string].split("_")[1]
      @next = Waypoint.find_by_id(next_id)
      @next.prev_waypoint = @waypoint
      @next.save
    end
    render :text => "waypoint_#{@waypoint.id}"
  end

  def update_waypoints
    @waypoint = Waypoint.find(params[:id])
    if @waypoint.next_waypoint and @waypoint.prev_waypoint 
      @next = @waypoint.next_waypoint
      @prev = @waypoint.prev_waypoint
      @next.prev_waypoint = @prev
      @next.save
    end
    
    if !@waypoint.prev_waypoint
      @next = @waypoint.next_waypoint
      @next.prev_waypoint = nil
      @next.save
    end

    if params[:prev_waypoint_as_string] != "false"
      @waypoint.prev_waypoint_id = params[:prev_waypoint_as_string].split("_")[1] 
    end
    @waypoint.save

    if params[:next_waypoint_as_string] != "false"
      next_id = params[:next_waypoint_as_string].split("_")[1]
      @next = Waypoint.find_by_id(next_id)
      @next.prev_waypoint = @waypoint
      @next.save
    end
    render :text => "ok"
  end

  def destroy
    waypoint = Waypoint.find(params[:id])
    position = waypoint.position
    if waypoint.next_waypoint and waypoint.prev_waypoint 
      @next = waypoint.next_waypoint
      @prev = waypoint.prev_waypoint
      @next.prev_waypoint = @prev
      @next.save
      waypoint.destroy
    end
    if !waypoint.prev_waypoint
      @next = waypoint.next_waypoint
      @next.prev_waypoint = nil
      @next.save
      waypoint.destroy
    end
    if !waypoint.next_waypoint
      waypoint.destroy
    end

    render :text => "#{position.class.to_s.downcase}_#{position.id}"
  end

end
