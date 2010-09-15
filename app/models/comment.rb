class Comment < ActiveRecord::Base
  belongs_to :position, :polymorphic => :true
  belongs_to :user

  def author
    if user
      user.name
    else
      "unknown"
    end
  end
end
