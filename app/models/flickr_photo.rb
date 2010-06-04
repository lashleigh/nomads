class FlickrPhoto < ActiveRecord::Base
  def url(size = 'm')
    "http://farm#{farm}.static.flickr.com/#{server}/#{photo_id}_#{secret}_#{size}.jpg"
  end

  def url_photopage
    "http://www.flickr.com/photos/lashleigh/#{photo_id}"
  end

  def self.from_flickr_fu(p)
    photo = self.new
    photo.photo_id = p.id
    photo.server = p.server
    photo.title = p.title
    photo.secret = p.secret
    photo.farm = p.farm

    photo.save
    return photo
  end

end
