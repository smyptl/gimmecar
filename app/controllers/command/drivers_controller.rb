class Command::DriversController < Command::BaseController

  before_action :authorize_driver, except: :index

  def index
    render status: 200, json: Services::Command::Drivers.fetch
  end

  def show
    render status: 200, json: Services::Command::Driver.fetch(id: id)
  end

  private

  def authorize_driver
    raise Error404 unless Driver.exists?(id: id)
  end

  def id
    params[:id]
  end
end
