class CommentsController < ApplicationController
  before_filter :must_be_user
  before_filter :must_own_comment, :only => [ :edit, :update, :destroy ]

  def index
    @comments = Comment.find(:all, :order => "created_at DESC")
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment]) 
    @comment.user = @user
    @comment.save
    redirect_to post_path(@post)
  end

  def update
    @comment.body = params[:comment][:body]
    flash[:notice] = "The comment was updated"
    @comment.save
    redirect_to @comment.position
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post)
  end

  private
  def must_own_comment
    unless params[:id]
      flash[:error] = "You must specify a comment!"
      redirect_to :controller => :home
      return false
    end
    @comment = Comment.find params[:id]
    unless @user and (@user.admin? or @user == @comment.user)
      flash[:error] = "You must own the comment you wish to modify."
      redirect_to :controller => :home
      return false
    end
  end
end
