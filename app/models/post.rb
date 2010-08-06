class Post < ActiveRecord::Base
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :lat
  validates_presence_of :lon
  has_many :comments
  belongs_to :user

  def as_hash
    { "id" => id,
      "link" => "posts/#{id}",
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => "/images/map_icons/blog.png",
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
