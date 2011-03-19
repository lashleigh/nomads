class ChangeDataTypeFlickrPhotoUploaded < ActiveRecord::Migration
  def self.up
    change_table :flickr_photos do |t|
      t.change :uploaded, :integer
    end
  end

  def self.down
    change_table :flick_photos do |t|
      t.change :uploaded, :datetime
    end
  end
end
