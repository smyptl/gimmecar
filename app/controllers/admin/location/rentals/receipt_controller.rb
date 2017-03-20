class Admin::Location::Rentals::ReceiptController < Admin::Location::BaseController

  def print
    render status: 200, :json => Services::Admin::Location::Rental::Print.new(rental_number: params[:rental_id]).fetch
  end

  def render_layout
    render 'admin/print_receipt'
  end
end
