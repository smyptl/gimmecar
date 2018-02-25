class Admin::Location::DashboardController < Admin::Location::BaseController

  def show
    Services::Admin::Location::Drivers::Search.new(params.require(:driver)).retrieve(success, failure)
  end
end
