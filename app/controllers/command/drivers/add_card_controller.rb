class Command::Drivers::AddCardController < Command::BaseController

  before_action :authorize_driver

  def create
    Actions::Command::Driver::AddCard.new(driver_id: id, token: params.fetch(:token)).execute(success, failure)
  end

  private

  def authorize_driver
    raise Error404 unless ::Driver.exists?(id: id)
  end

  def id
    params[:driver_id]
  end
end
