class Post < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :lat
  validates_presence_of :lon
  has_many :comments, :as => :position
  has_one :waypoint, :as => :position
  belongs_to :user

  def as_hash
    { "id" => id,
      "link" => "posts/#{id}",
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => "/images/map_icons/blog.png",
      "user" => user.nickname,
      "content" => textilize(short_content) }
  end

  def short_content(maxlen = 100)
    s = content[0..maxlen]
    if( s.length > maxlen and s.include? ' ')
      s[0..s.rindex(' ')-1] + '...'
    else
      s
    end
  end

  def author
    if user
      user.name
    else
      "unknown"
    end
  end
end
