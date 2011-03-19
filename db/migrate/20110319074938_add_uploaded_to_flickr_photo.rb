class AddUploadedToFlickrPhoto < ActiveRecord::Migration
  def self.up
    add_column :flickr_photos, :uploaded, :datetime
  end

  def self.down
    remove_column :flickr_photos, :uploaded
  end
end
