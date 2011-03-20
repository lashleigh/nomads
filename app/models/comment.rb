class Comment < ActiveRecord::Base
  validates_presence_of :position
  validates_presence_of :user
  validates_presence_of :body
  belongs_to :position, :polymorphic => :true
  belongs_to :user

  include Author 
  
  def position_name
    if position
      position.title
    else
      "unknown"
    end
  end
end
