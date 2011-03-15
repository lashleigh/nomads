# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_user

  protected
  def must_be_admin
    unless @user and @user.admin?
      flash[:error] = "You are not authorized to use this portion of the site."
      redirect_to :controller => :home
      return false
    end
  end

  def must_be_user
    unless @user
      flash[:error] = "You must be logged in use this portion of the site."
      redirect_to :controller => :home
      return false
    end
  end

  private
  def set_user 
    if session[:user]
      @user = User.find_by_id session[:user]
      session[:user] = nil unless @user
    end
  end
end
