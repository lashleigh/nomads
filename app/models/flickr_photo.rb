class FlickrPhoto < ActiveRecord::Base
  validates_uniqueness_of :photo_id

  def as_hash
    { "id" => id,
      "url" => url,
      "latitude" => lat,
      "longitude" => lon,
      "title" => title }
  end

  def url(size = 'm')
    "http://farm#{farm}.static.flickr.com/#{server}/#{photo_id}_#{secret}_#{size}.jpg"
  end

  def url_photopage
    "http://www.flickr.com/photos/lashleigh/#{photo_id}"
  end
end
