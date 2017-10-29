class Admin::Location::BaseController < ApplicationController
  include Admin::Concerns::User
  include Admin::Concerns::Api

  before_action :authenticate_user, :authenticate_location, :authorize_api

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

  def success
    lambda do |args|
      render status: 200, :json => args
    end
  end

  def failure
    lambda do |args|
      render status: 400, :json => args
    end
  end
end
