class CommentsController < ApplicationController
  before_filter :must_own_comment, :except => [:index, :create]

  def index
    if params[:since]
      @comments = Comment.find :all, :order => "created_at DESC", :conditions => [ "updated_at > ?",  params[:since] ]
    else
      @comments = Comment.find :all, :order => "created_at DESC"
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @comments }
      format.xml { render :xml => @comments }
    end
  end

  def show
    comment = Comment.find params[:id]
    respond_to do |format|
      format.html redirect_to comment.position
      format.json { render :json => @comment }
      format.xml { render :xml => @comment }
    end
  end

  def create
    @parent = parent_object
    @comment = @parent.comments.create(params[:comment]) 
    @comment.user = @user
    @comment.save
    redirect_to url_for(@parent)
 end

  def update
    @comment.body = params[:comment][:body]
    flash[:notice] = "The comment was updated"
    @comment.save
    redirect_to @comment.position
  end

  def destroy
    @parent = parent_object
    #@comment = @parent.comments.find(params[:id])
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to url_for(@parent)
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

  def parent_object
    case
    when params[:post_id] then Post.find(params[:post_id])
    when params[:suggestion_id] then Suggestion.find(params[:suggestion_id])
    end    
  end  

end

