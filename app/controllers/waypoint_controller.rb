class WaypointController < ApplicationController

  def new
    @waypoint = Waypoint.new
    @waypoint.position_id = params[:position_as_string].split("_")[1] 
    @waypoint.position_type = params[:position_as_string].split("_")[0].capitalize
    if params[:prev_waypoint_as_string]
      @waypoint.prev_waypoint_id = params[:prev_waypoint_as_string].split("_")[1] 
    end
    @waypoint.save

    if params[:next_waypoint_as_string]
      next_id = params[:next_waypoint_as_string].split("_")[1]
      @next = Waypoint.find_by_id(next_id)
      @next.prev_waypoint = @waypoint
      @next.save
    end
    render :text => "ok"
  end

end
