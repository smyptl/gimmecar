class Admin::Location::RatesController < Admin::Location::BaseController

  def index
    render status: 200, json: Services::Admin::Location::Rates.fetch(location.id)
  end

  def show
  end

  private

  def authorize_rental
    raise Error404 unless @location.rental_numbers.include?(rental_number)
  end

  def rental_number
    params[:id]
  end
end
