class Admin::Location::RentalsController < Admin::Location::BaseController

  def index
    render status: 200, json: Services::Admin::Rentals.fetch(location.id)
  end

  def show
  end
end
