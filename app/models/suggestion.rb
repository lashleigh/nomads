class Suggestion < ActiveRecord::Base
  has_one :waypoint
  belongs_to :icon
  belongs_to :user
  validates_presence_of :user_id, :message => "must be logged in"
  validates_presence_of :icon, :message => "must be selected"
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :lat
  validates_presence_of :lon

  def as_hash
    { "id" => id,
      "link" => "suggestions/#{id}",
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => icon ? icon.marker_url : "/images/map_icons/misc.png",
      "user" => user.name,
      "content" => textilize(shorten(content)) }
  end

  def shorten(content)
    maxlen = 100
    s = content[0..maxlen]
    if s.include? ' '
      s[0..s.rindex(' ')-1] + '...'
    else
      s
    end
  end
end
