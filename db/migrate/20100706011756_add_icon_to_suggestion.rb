class AddIconToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :icon_id, :integer
  end

  def self.down
    remove_column :suggestions, :icon_id
  end
end
