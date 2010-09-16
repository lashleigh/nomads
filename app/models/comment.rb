class Comment < ActiveRecord::Base
  validates_presence_of :position
  belongs_to :position, :polymorphic => :true
  belongs_to :user

  def author
    if user
      user.name
    else
      "unknown"
    end
  end

  def position_name
    if position
      position.title
    else
      "unknown"
    end
  end
end
