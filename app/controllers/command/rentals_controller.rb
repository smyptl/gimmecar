class Command::RentalsController < Command::BaseController

  before_action :authorize_rental, except: :index

  def index
    Services::Command::Rentals.retrieve(success, failure)
  end

  def show
    Services::Command::Rental.new(number: number).retrieve(success, failure)
  end

  private

  def authorize_rental
    raise Error404 unless ::Rental.exists?(number: number)
  end

  def number
    params[:id]
  end
end
