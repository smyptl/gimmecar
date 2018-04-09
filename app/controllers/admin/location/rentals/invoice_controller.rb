class Admin::Location::Rentals::InvoiceController < Admin::Location::Rentals::BaseController

  def print
    Services::Admin::Location::Rental::Invoice.new(number: number).retrieve(success, failure)
  end
end
