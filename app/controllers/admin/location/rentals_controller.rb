class Admin::Location::RentalsController < Admin::Location::BaseController

  before_action :authorize_rental, except: [:index]

  def index
    render status: 200, json: Services::Admin::Location::Rentals.fetch(location.id)
  end

  def show
    render status: 200, json: Services::Admin::Rental.fetch(number: number)
  end

  private

  def authorize_rental
    raise Error404 unless @location.rentals.exists?(number: number)
  end

  def number
    params[:id]
  end
end
