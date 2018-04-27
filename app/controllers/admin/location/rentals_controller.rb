class Admin::Location::RentalsController < Admin::Location::BaseController

  before_action :authorize_rental, except: [:index]

  def index
    Services::Admin::Location::Rentals.retrieve(success, failure, location_id: location.id)
  end

  def show
    Services::Admin::Location::Rental::Information.new(number: number, slug: location.slug).retrieve(success, failure)
  end

  private

  def authorize_rental
    raise Error404 unless @location.rentals.exists?(number: number)
  end

  def number
    params[:id]
  end
end
