class UsersController < ApplicationController
  def index
    if params[:since]
      @users = User.find(:all, :conditions =>[ "updated_at > ?",  params[:since] ])
    else
      @users = User.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => tidy(@users) }
    end
  end

  private
  def tidy(users)
    users.collect do |u|
      { :user => 
        { :name         => u.name,
          # Omitting email and openid for security reasons
          #:openid       => u.openid,
          #:email        => u.email,
          :id           => u.id,
          :fullname     => u.fullname,
          :created_at   => u.created_at,
          :updated_at   => u.updated_at,
          :admin        => u.admin }
      }
    end
  end
end
