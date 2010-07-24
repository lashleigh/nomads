class CreateWaypoints < ActiveRecord::Migration
  def self.up
    create_table :waypoints do |t|
      t.integer :prev_waypoint_id
      t.integer :suggestion_id

      t.timestamps
    end
  end

  def self.down
    drop_table :waypoints
  end
end
