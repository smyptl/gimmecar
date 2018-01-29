class Admin::Location::Rentals::ReceiptController < Admin::Location::Rentals::BaseController

  def print
    render status: 200, :json => Services::Admin::Location::Rental::Print.new(number: number).fetch
  end

  def render_layout
    render 'admin/print_receipt'
  end
end
