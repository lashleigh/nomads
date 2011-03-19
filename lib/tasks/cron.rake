task :cron => "flickr:update"
task :flickr => "flickr:update"

namespace :flickr do
  task :reset => [ :destroy, :update ]

  task :update => :environment do
    result = flickr.photos.search(:user_id => "23276058@N04", :tags => "nomad", :extras => "geo, title, date_upload").to_a +
      flickr.photos.search(:user_id => "49191687@N05", :tags => "nomad", :extras => "geo, title, date_upload").to_a

    result.reverse.each do |p|
      photo = FlickrPhoto.find_or_create_by_photo_id(:photo_id => p.id)
      photo.server = p.server
      photo.title = p.title
      photo.secret = p.secret
      photo.farm = p.farm
      photo.lat = p.latitude
      photo.lon = p.longitude
      photo.uploaded = p.dateupload

      photo.save
    end
  end

  task :destroy => :environment do
    FlickrPhoto.destroy_all
  end
end
