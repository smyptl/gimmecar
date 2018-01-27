class Command::RentalsController < Command::BaseController

  before_action :authorize_rental, except: :index

  def index
    render status: 200, json: Services::Command::Rentals.fetch
  end

  def show
    render status: 200, json: Services::Command::Rental.fetch(number: number)
  end

  private

  def authorize_rental
    raise Error404 unless ::Rental.exists?(number: number)
  end

  def number
    params[:id]
  end
end
