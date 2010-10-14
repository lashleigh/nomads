class CommentsController < ApplicationController
  before_filter :must_own_comment, :only => [ :edit, :update, :destroy ]

  def index
    @comments = Comment.find(:all, :order => "created_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @comments }
      format.xml { render :xml => @comments }
    end
  end

  def create
    comment = Comment.new params[:comment]
    comment.user = @user
    comment.save
    redirect_to comment
  end

  def show
    comment = Comment.find params[:id]
    respond_to do |format|
      format.html { redirect_to comment.position }
      format.json { render :json => comment }
      format.xml { render :xml => comment }
    end
  end

  def update
    @comment.body = params[:comment][:body]
    flash[:notice] = "The comment was updated"
    @comment.save
    redirect_to @comment.position
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Comment was removed"
    redirect_to @comment.position
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
