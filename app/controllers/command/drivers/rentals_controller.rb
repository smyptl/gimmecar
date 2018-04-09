class Command::Drivers::RentalsController < Command::Drivers::BaseController

  def index
    Services::Command::Driver::Rentals.new(id: id).retrieve(success, failure)
  end
end
