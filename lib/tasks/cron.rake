task :cron => :environment do
  result = flickr.photos.search(:user_id => "23276058@N04", :tags => "nomad", :extras => "geo, title").to_a +
           flickr.photos.search(:user_id => "49191687@N05", :tags => "nomad", :extras => "geo, title").to_a
          
  result.each do |p|
    photo = FlickrPhoto.find_or_create_by_photo_id(:photo_id => p.id)
    photo.server = p.server
    photo.title = p.title
    photo.secret = p.secret
    photo.farm = p.farm
    photo.lat = p.latitude
    photo.lon = p.longitude

    photo.save
  end
end



