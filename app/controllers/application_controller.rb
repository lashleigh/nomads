class ApplicationController < ActionController::Base
  protect_from_forgery 
  helper :all 
  before_filter :set_user
  before_filter :dump_session

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
  def dump_session
    logger.info "/n/n"
    logger.info session.to_json
    logger.info "/n/n"
  end

end
