class UsersController < ApplicationController
  def index
    if params[:since]
      @users = User.find(:all, :conditions => [ "updated_at > ?",  params[:since] ])
    else
      @users = User.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users.to_json(:only => [ :name, :fullname, :created_at, :updated_at, :admin ]) }
    end
  end

  def show
    @user = User.find(params[:id])
    @items = get_items(@user.id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user.to_json(:only => [ :name, :fullname, :created_at, :updated_at, :admin ]) }
    end
  end

  private
  def get_items(user_id)
    suggestions = Suggestion.where("user_id = ?", user_id).order("created_at DESC")
    comments = Comment.where("user_id = ?", user_id).order("created_at DESC")
    posts = Post.published.where("user_id = ?", user_id).order("created_at DESC")
    @items = (suggestions + comments + posts).sort_by { |i| i.created_at }.reverse
  end
end
