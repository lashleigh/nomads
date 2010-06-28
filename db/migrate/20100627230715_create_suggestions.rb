class CreateSuggestions < ActiveRecord::Migration
  def self.up
    create_table :suggestions do |t|
      t.string :name
      t.string :type
      t.text :content
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end

  def self.down
    drop_table :suggestions
  end
end
