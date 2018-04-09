class Command::Drivers::BaseController < Command::BaseController

  before_action :authorize_driver

  private

  def authorize_driver
    raise Error404 unless ::Driver.exists?(id: id)
  end

  def id
    params[:driver_id]
  end
end
