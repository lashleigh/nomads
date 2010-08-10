class WaypointController < ApplicationController

  def new
    @waypoint = Waypoint.new
    @waypoint.position_id = params[:position_as_string].split("_")[1] 
    @waypoint.position_type = params[:position_as_string].split("_")[0].capitalize
    @waypoint.prev_waypoint_id = params[:prev_waypoint_as_string].split("_")[1] 

    @waypoint.save
    logger.info @waypoint.errors.full_messages
    render :text => "ok"
  end

end
