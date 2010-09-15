class ConvertCommentsToPolymorphicAssociation < ActiveRecord::Migration
  def self.up
    add_column :comments, :position_id, :integer
    add_column :comments, :position_type, :string
    Comment.all.each do |c|
      c.position_id = c.post_id
      c.position_type = "Post"
    end
    remove_column :comments, :post_id
  end

  def self.down
    add_column :comments, :post_id, :integer
    Comment.all.each do |c|
      if c.position_type == "Post"
        c.post_id = c.position_id 
      else
        c.destroy
      end
    end
    remove_column :comments, :position_type
    remove_column :comments, :position_id
  end
end
