class ChangeUploadedFormatToString < ActiveRecord::Migration
  def self.up
    change_table :flickr_photos do |t|
      t.change :uploaded, :string
    end
  end

  def self.down
    change_table :flick_photos do |t|
      t.change :uploaded, :datetime
    end
  end
end
