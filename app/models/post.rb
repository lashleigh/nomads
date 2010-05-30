class Post < ActiveRecord::Base
   validates_presence_of :name, :title  
   validates_length_of :title, :minimum => 5 
   has_many :comments
end
