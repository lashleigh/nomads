class Suggestion < ActiveRecord::Base
  belongs_to :icon
  belongs_to :user
  validates_presence_of :user_id, :message => "must be logged in"
  validates_presence_of :icon, :message => "must be selected"
  validates_presence_of :title
  validates_presence_of :content

  def as_hash
    { "id" => id,
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => icon ? icon.marker_url : "/images/map_icons/misc.png",
      "user" => user.name,
      "content" => content }
  end
end
