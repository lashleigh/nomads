class Post < ActiveRecord::Base
   validates_presence_of :title
   has_many :comments
   belongs_to :user

  def as_hash
    { "id" => id,
      "title" => title,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => "/images/map_icons/blog.png",
      "content" => content }
  end

end
