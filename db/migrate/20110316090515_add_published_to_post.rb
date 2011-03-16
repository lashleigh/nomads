class AddPublishedToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :published, :boolean, :default => false
    Post.all.each do |post|
      post.published = true
      post.save(false)
    end
  end

  def self.down
    remove_column :posts, :published
  end
end
