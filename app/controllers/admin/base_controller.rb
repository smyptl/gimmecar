class Admin::BaseController < ApplicationController

  helper_method :location, :current_user

  before_action :authorize_api

  layout 'admin'

  private

  def authorize_api
    #render 'admin/index' unless api?
  end

  def api?
    request.xhr?
  end

  def authenticate_user
    return if current_user

    if api?
      head 404
    else
      raise Error404
    end
  end

  def current_user
    @current_user ||= begin
                        User.authenticate_by_token(token)
                      rescue
                        nil
                      end
  end

  def token
    cookies.encrypted[:token]
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
