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
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => "/images/map_icons/blog.png",
      "user" => user.name,
      "content" => textilize(shorten(content)) }
  end

  def shorten(content)
    if content.length > 150
      content[0..150] + "..."
    else
      content
    end
  end

end
