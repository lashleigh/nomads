task :cron => :environment do
  result = flickr.photos.search(:user_id => "49191687@N05", :tags => "nomad", :extras => "geo, title")
  result.each do |p|
    photo = FlickrPhoto.new
    photo.photo_id = p.id
    photo.server = p.server
    photo.title = p.title
    photo.secret = p.secret
    photo.farm = p.farm
    photo.lat = p.latitude
    photo.lon = p.longitude

    photo.save
  end
end



