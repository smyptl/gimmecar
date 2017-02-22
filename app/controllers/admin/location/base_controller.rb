class Admin::Location::BaseController < ApplicationController
  include Admin::Concerns::User
  include Admin::Concerns::Api

  before_action :authenticate_user, :authenticate_location, :authorize_api

  helper_method :location

  layout 'admin'

  private

  def render_layout
    render 'admin/location'
  end

  def authenticate_location
    return if location

    if api?
      head 404
    else
      raise ApplicationController::Error404
    end
  end

  def location
    @location ||= current_user.locations.try(:find_by, slug: params[:slug]) if current_user
  end
end