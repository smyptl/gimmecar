class Admin::Location::Rentals::ReceiptController < Admin::Location::Rentals::BaseController

  def print
    Services::Admin::Location::Rental::Print.new(number: number).retrieve(success, failure)
  end

  def render_layout
    render 'admin/receipt'
  end
end
