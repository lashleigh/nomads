class Suggestion < ActiveRecord::Base
  belongs_to :icon
  validates_presence_of :name
  validates_presence_of :content
end
