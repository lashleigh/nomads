class CommentsController < ApplicationController
  before_filter :must_be_user
  def post
    post = Post.find params[:id]
    comment = Comment.new
    comment.position = post
    comment.body = params[:comment][:body]
    comment.user = @user
    comment.save
    redirect_to post
  end
end
