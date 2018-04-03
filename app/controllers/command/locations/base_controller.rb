class Command::Locations::BaseController < Command::BaseController

  before_action :authorize_locations

  private

  def authorize_locations
    raise Error404 unless ::Location.exists?(slug: slug)
  end

  def slug
    params[:location_id]
  end
end
