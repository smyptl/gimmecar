class Admin::Location::RentalsController < Admin::Location::BaseController

  before_action :authorize_rental, except: [:index]

  def index
    render status: 200, json: Services::Admin::Rentals.fetch(location.id)
  end

  def show
    render status: 200, json: Services::Admin::Rental.fetch(rental_number: rental_number)
  end

  private

  def authorize_rental
    raise Error404 unless @location.rental_numbers.include?(rental_number)
  end

  def rental_number
    params[:id]
  end
end
