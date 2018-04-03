class Command::Locations::RentalsController < Command::Locations::BaseController

  def index
    Services::Command::Location::Rentals.new(slug: slug).retrieve(success, failure)
  end
end
