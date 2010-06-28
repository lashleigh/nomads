class FixNameLongitude < ActiveRecord::Migration
  def self.up
    rename_column :flickr_photos, :long, :lon
  end

  def self.down
    rename_column :flickr_photos, :lon, :long
  end
end
