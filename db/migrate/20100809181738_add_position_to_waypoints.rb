class AddPositionToWaypoints < ActiveRecord::Migration
  def self.up
    rename_column :waypoints, :suggestion_id, :position_id 
  end

  def self.down
    rename_column :waypoints, :position_id, :suggestion_id 
  end
end
