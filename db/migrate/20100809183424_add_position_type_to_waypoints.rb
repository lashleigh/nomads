class AddPositionTypeToWaypoints < ActiveRecord::Migration
  def self.up
    add_column :waypoints, :position_type, :string
  end

  def self.down
    remove_column :waypoints, :position_type
  end
end
