class Admin::Location::Rentals::ReceiptController < Admin::Location::Rentals::BaseController

  def print
    Services::Admin::Location::Rental::Print.new(number: number).retrieve(sucess, failure)
  end

  def render_layout
    render 'admin/print_receipt'
  end
end
