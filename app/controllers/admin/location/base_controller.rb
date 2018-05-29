class Admin::Location::BaseController < Admin::BaseController

  before_action :authenticate_location

  private

  def authenticate_location
    head 404 unless location?
  end

  def location
    @location ||= current_user.locations.try(:find_by, slug: params[:slug]) if current_user?
  end

  def location?
    location.present?
  end
end
