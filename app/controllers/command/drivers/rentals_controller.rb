class Command::Drivers::RentalsController < Command::BaseController

  before_action :authorize_driver

  def index
    Services::Command::Driver::Rentals.new(id: id).retrieve(success, failure)
  end

  private

  def authorize_driver
    raise Error404 unless ::Driver.exists?(id: id)
  end

  def id
    params[:driver_id]
  end
end