class Admin::LocationsController < Admin::BaseController

  def index
    Services::Admin::User::Locations.retrieve(success, failure, user: current_user)
  end
end
