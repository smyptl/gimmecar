class Command::Rentals::InvoiceController < Command::Rentals::BaseController

  def index
    Services::Command::Rental::Invoice.new(number: number).retrieve(success, failure)
  end
end
