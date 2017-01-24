class Admin::Location::DashboardController < Admin::BaseController

  before_action :authenticate_user, :authenticate_location

  def index
  end
end
