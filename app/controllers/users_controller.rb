class UsersController < ApplicationController
  def index
    if params[:since]
      @users = User.find(:all, :conditions => [ "updated_at > ?",  params[:since] ])
    else
      @users = User.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => tidy(@users) }
    end
  end
  def show
    @user = User.find(params[:id])
    @items = get_items(@user.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => tidy(@users) }
    end
  end

  private
  def tidy(users)
    users.collect do |u|
      { :user => 
        { :name         => u.name,
          # Omitting email and openid for security reasons
          #:openid       => u.openid,
          #:email        => u.email,
          :id           => u.id,
          :fullname     => u.fullname,
          :created_at   => u.created_at,
          :updated_at   => u.updated_at,
          :admin        => u.admin }
      }
    end
  end
  def get_items(user_id)
    suggestions = Suggestion.where("user_id = ?", user_id).order("created_at DESC")
    comments = Comment.where("user_id = ?", user_id).order("created_at DESC")
    posts = Post.published.where("user_id = ?", user_id).order("created_at DESC")
    @items = (suggestions + comments + posts).sort_by { |i| i.created_at }.reverse
  end
end
