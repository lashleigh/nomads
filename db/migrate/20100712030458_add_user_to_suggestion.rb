class AddUserToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :user_id, :integer
  end

  def self.down
    remove_column :suggestions, :user_id
  end
end
