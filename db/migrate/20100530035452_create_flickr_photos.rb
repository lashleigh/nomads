class CreateFlickrPhotos < ActiveRecord::Migration
  def self.up
    create_table :flickr_photos do |t|
      t.string :title
      t.integer :farm
      t.string :secret
      t.string :photo_id
      t.string :server

      t.timestamps
    end
  end

  def self.down
    drop_table :flickr_photos
  end
end
