class UseUserAccountsInComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :user_id, :integer
    remove_column :comments, :commenter
  end

  def self.down
    add_column :comments, :commenter, :string
    remove_column :comments, :user_id
  end
end
