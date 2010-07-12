# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_user
  
  private
  def set_user 
    if session[:user]
      @user = User.find_by_id session[:user]
      session[:user] = nil unless @user
    end
  end
end
