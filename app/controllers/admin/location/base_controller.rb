class Admin::Location::BaseController < ApplicationController
  include Admin::Concerns::User

  helper_method :location, :current_user

  before_action :authorize_api, :authenticate_user, :authenticate_location

  layout 'admin'

  private

  def authorize_api
    render 'admin/location' unless api?
  end

  def api?
    request.xhr?
  end

  def authenticate_location
    return if location

    if api?
      head 404
    else
      Error404
    end
  end

  def location
    @location ||= current_user.locations.try(:find_by, slug: params[:slug]) if current_user
  end
end
