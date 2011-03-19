class FeedsController < ApplicationController
  def atom
    @posts = Post.published.order("created_at DESC")
    render :layout => false
  end
end
