class FeedsController < ApplicationController
  def atom
    @posts = Post.where("published = ?", true).order("created_at DESC")
    render :layout => false
  end
end
