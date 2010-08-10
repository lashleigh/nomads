class Waypoint < ActiveRecord::Base
  belongs_to :position, :polymorphic => true

  belongs_to :prev_waypoint, :class_name => "Waypoint"
  has_one :next_waypoint, :class_name => "Waypoint", :foreign_key => :prev_waypoint_id

  validates_presence_of :position

  def self.full_track
    waypoints = Waypoint.all
    return [] unless waypoints.length > 0
    starting_point = waypoints[0]

    id_to_waypoint = Hash[waypoints.collect { |w| [w.id, w] }]
    prevs = {}
    nexts = {}
    waypoints.each do |w|
      prev = id_to_waypoint[w.prev_waypoint_id]
      prevs[w] = prev
      nexts[prev] = w
    end

    reverse_track = []
    p = starting_point
    while prevs[p]
      p = prevs[p]
      reverse_track.insert(0,p)
    end

    forward_track = []
    p = starting_point
    while nexts[p]
      p = nexts[p]
      forward_track << p
    end

    reverse_track + [starting_point] + forward_track
  end

  def self.full_track_points
    Waypoint.full_track.collect { |p| [ p.position.lat, p.position.lon ] }
  end

end
