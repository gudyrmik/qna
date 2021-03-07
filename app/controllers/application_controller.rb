class ApplicationController < ActionController::Base
  before_action :set_params_for_gon

  private

  def set_params_for_gon
    gon.current_user_id = current_user.id if current_user
  end
end
