class Command::LocationsController < Command::BaseController

  before_action :authorize_location, except: :index

  def index
    Services::Command::Locations.retrieve(success, failure)
  end

  def show
    Services::Command::Location::Information.new(slug: slug).retrieve(success, failure)
  end

  private

  def authorize_location
    raise Error404 unless ::Location.exists?(slug: slug)
  end

  def slug
    params[:id]
  end
end
