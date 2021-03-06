class LinksController < ApplicationController

  before_action :authenticate_user!, only: :destroy
  before_action :find_link

  authorize_resource

  def destroy
    @link.destroy if current_user&.is_author?(@link.linkable)
  end

  private

  def find_link
    @link = Link.find(params[:id])
  end
end
