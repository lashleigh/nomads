class Waypoint < ActiveRecord::Base
  belongs_to :position, :polymorphic => true

  belongs_to :prev_waypoint, :class_name => "Waypoint"
  has_one :next_waypoint, :class_name => "Waypoint", :foreign_key => :prev_waypoint_id
  validates_presence_of :position

  def insert_between(x = nil, y = nil)
    self.remove_from_track

    before = x
    after = y

    before.next_waypoint = self
    self.next_waypoint = after

    before.save
    self.save
    after.save
  end

  def remove_from_track
    before = self.prev_waypoint
    after = self.next_waypoint

    before.next_waypoint = after
    self.prev_waypoint = nil

    before.save
    self.save
    after.save
  end

  def self.full_track
    waypoints = Waypoint.all
    return [] unless waypoints.length > 0
    starting_point = waypoints[0]

    id_to_waypoint = Hash.new
    waypoints.each { |w| id_to_waypoint[w.id] = w }

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

  def title
    if position
      position.title
    else
      "untitled"
    end
  end
end
