class Admin::ConfigurableSettingsController < ApplicationController
  before_filter :login_required, :admin_required
  active_scaffold :configurable_settings
end

