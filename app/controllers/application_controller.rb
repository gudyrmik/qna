class ApplicationController < ActionController::Base
  before_action :set_params_for_gon

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render nothing: true, status: :not_found }
      format.html { redirect_to root_url, notice: exception.message, status: :not_found }
      format.js { render nothing: true, status: :not_found }
    end
  end

  private

  def set_params_for_gon
    gon.current_user_id = current_user.id if current_user
  end
end
