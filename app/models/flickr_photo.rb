class FlickrPhoto < ActiveRecord::Base
  validates_uniqueness_of :photo_id
  FlickRawOptions = {
    "api_key" => "102b5abb3630dfebf56162816ce764c9",
    "shared_secret" => "de4a6e8f592ce5a1",
    "auth_token" => "72157624183057188-2a2cfd75aee7b532",
  }

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
