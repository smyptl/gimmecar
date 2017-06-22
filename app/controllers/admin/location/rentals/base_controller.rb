class Admin::Location::Rentals::BaseController < Admin::Location::BaseController

  before_action :authorize_rental

  def authorize_rental
    raise Error404 unless @location.rental_numbers.include?(rental_number)
  end

  def rental_number
    params[:rental_id]
  end
end
