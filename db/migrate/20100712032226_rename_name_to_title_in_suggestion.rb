class RenameNameToTitleInSuggestion < ActiveRecord::Migration
  def self.up
    rename_column :suggestions, :name, :title 
  end

  def self.down
    rename_column :suggestions, :title, :name 
  end
end
