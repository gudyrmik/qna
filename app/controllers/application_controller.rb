class ApplicationController < ActionController::Base
  before_action :set_params_for_gon

  authorize_resource

  rescue_from CanCan: AcessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def set_params_for_gon
    gon.current_user_id = current_user.id if current_user
  end
end
