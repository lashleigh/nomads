class CommentsController < ApplicationController
  before_filter :must_be_user
  before_filter :must_own_comment, :only => [ :update, :destroy ]
  def post
    post = Post.find params[:id]
    comment = Comment.new
    comment.position = post
    comment.body = params[:comment][:body]
    comment.user = @user
    comment.save
    redirect_to post
  end

  def suggestion
    suggestion = Suggestion.find params[:id]
    comment = Comment.new
    comment.position = suggestion
    comment.body = params[:comment][:body]
    comment.user = @user
    comment.save
    redirect_to suggestion
  end

  def update
    comment = Comment.find params[:id]
    comment.body = params[:comment][:body]
    comment.save
  end
end
