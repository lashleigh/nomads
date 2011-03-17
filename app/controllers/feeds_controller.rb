class FeedsController < ApplicationController
  def atom
    @posts = Post.where("visible = ?", true).order("created_at DESC")
    render :layout => false
  end
end
