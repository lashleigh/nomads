class RemoveSugggestionType < ActiveRecord::Migration
  def self.up
    remove_column :suggestions, :suggestion_type  
  end

  def self.down
    add_column :suggestions, :suggestion_type  
  end
end
