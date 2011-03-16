class ActivityController < ApplicationController
  def index
    n = params[:n].to_i
    if n <= 0
      # Default number of items
      n = 12
    end
    suggestions = Suggestion.find :all, :order => "created_at DESC"
    comments = Comment.find :all, :order => "created_at DESC"
    posts = Post.find :all, :order => "created_at DESC"
    @items = (suggestions + comments + posts).sort_by { |i| i.created_at }.last(n).reverse
  end
end
