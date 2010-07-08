class AddLatLonToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :lat, :float
    add_column :posts, :lon, :float
  end

  def self.down
    remove_column :posts, :lon
    remove_column :posts, :lat
  end
end
