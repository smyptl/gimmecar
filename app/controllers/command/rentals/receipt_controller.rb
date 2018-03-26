class Command::Rentals::ReceiptController < Command::BaseController

  before_action :authorize_rental

  def print
    Services::Command::Rental::Print.new(number: number).retrieve(success, failure)
  end

  private

  def render_layout
    render 'command/receipt'
  end

  def authorize_rental
    raise Error404 unless ::Rental.exists?(number: number)
  end

  def number
    params[:rental_id]
  end
end
