class FeedsController < ApplicationController
  def atom
    @posts = Post.all.reverse
    render :layout => false
  end
end
