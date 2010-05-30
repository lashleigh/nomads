class CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])  
    @comments = @post.comments 
  end

  def show
    @post = Post.find(params[:post_id])  
    @comment = @post.comments.find(params[:id])  
  end

  def new
    @post = Post.find(params[:post_id])  
    @comment = @post.comments.build 
  end

  def edit
    @post = Post.find(params[:post_id])  
    @comment = @post.comments.find(params[:id])  
  end

  def create
    @post = Post.find(params[:post_id])  
    @comment = @post.comments.build(params[:comment]) 
    if @comment.save 
      redirect_to post_comment_url(@post, @comment)  
    else  
      render :action => "new"  
    end 
  end

  def update
    @post = Post.find(params[:post_id])  
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])  
      redirect_to post_comment_url(@post, @comment)  
    else  
      render :action => "edit"  
    end 
  end

  def destroy
    @post = Post.find(params[:post_id])  
    @comment = Comment.find(params[:id])
    @comment.destroy 
    
    respond_to do |format| 
      format.html { redirect_to post_comments_path(@post) } 
      format.xml { head :ok } 
    end 
  end
end
