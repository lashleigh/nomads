class Admin::UserController < ApplicationController
  layout "admin"

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [:activate],
         :redirect_to => { :action => "activate_error" }

  def activate
    @user = User.find(params[:id])
    if @user.activated?
      flash.now[:notice] = "#{@user.login} is already activated."
    elsif @user.activate!
      flash.now[:notice] = "Activated #{@user.login}."
    else
      flash.now[:notice] = "Cannot activate #{@user.login}."
    end
  end

  def activate_error
    render :text => "Failed to activate. Invalid method #{request.env['REQUEST_METHOD']}"
  end

  active_scaffold :user do |config|    
    config.columns = [:login, 
      :email,
      :password,
      :password_confirmation,
      :activated?,
      :activated_at,
      :time_zone,
      :_configurable_settings ]

    config.columns[:time_zone].form_ui = [:time_zone]

    config.list.columns.exclude [ 
      :password,
      :password_confirmation ]

    config.create.columns.exclude [ 
      :activated?,
      :activated_at ]

    config.update.columns.exclude [ 
      :login,
      :activated?,
      :activated_at ]

    excluded = [:created_at, 
      :updated_at, :remember_token, :remember_token_expires_at,
      :salt, :activation_code, :crypted_password]

    config.list.columns.exclude excluded
    config.create.columns.exclude excluded
    config.update.columns.exclude excluded

    config.action_links.add('activate',
      :label => 'Activate',
      :type => :record,
      :method => :post,
      :inline => true,
      :crud_type => :update)

  end
end

