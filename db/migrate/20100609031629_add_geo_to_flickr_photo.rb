class AddGeoToFlickrPhoto < ActiveRecord::Migration
  def self.up
    add_column :flickr_photos, :lat, :float
    add_column :flickr_photos, :long, :float
  end

  def self.down
    remove_column :flickr_photos, :long
    remove_column :flickr_photos, :lat
  end
end
