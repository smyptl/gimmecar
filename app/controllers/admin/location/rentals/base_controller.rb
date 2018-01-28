class Admin::Location::Rentals::BaseController < Admin::Location::BaseController

  before_action :authorize_rental

  def authorize_rental
    raise Error404 unless @location.rentals.exists?(number: number)
  end

  def number
    params[:rental_id]
  end
end
