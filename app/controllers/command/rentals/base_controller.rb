class Command::Rentals::BaseController < Command::BaseController

  before_action :authorize_rental

  private

  def authorize_rental
    raise Error404 unless ::Rental.exists?(number: number)
  end

  def number
    params[:rental_id]
  end
end
