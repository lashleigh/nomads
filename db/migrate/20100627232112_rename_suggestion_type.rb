class RenameSuggestionType < ActiveRecord::Migration
  def self.up
    rename_column :suggestions, :type, :suggestion_type
  end

  def self.down
    rename_column :suggestions, :suggestion_type, :type
  end
end
