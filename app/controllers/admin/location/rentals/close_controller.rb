class Admin::Location::Rentals::CloseController < Admin::Location::Rentals::BaseController

  def index
  end

  def create
    Actions::Admin::Location::Rental::Close.new(params.require(:close)).execute(success, failure, params)
  end
end
