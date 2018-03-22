class Command::Rentals::ExtendController < Command::BaseController

  before_action :authorize_rental

  def index
    Services::Command::Rental::Extend.new(number: number).retrieve(success, failure)
  end

  def create
    Actions::Command::Rental::Extend.new(params.require(:extend).merge(number: number)).execute(success, failure)
  end

  private

  def authorize_rental
    raise Error404 unless ::Rental.exists?(number: number)
  end

  def number
    params[:rental_id]
  end
end
