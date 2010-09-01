class FeedsController < ApplicationController
  def atom
    @posts = Post.find :all, :order => "created_at DESC"
    render :layout => false
  end
end
