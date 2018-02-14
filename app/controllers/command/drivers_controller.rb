class Command::DriversController < Command::BaseController

  before_action :authorize_driver, except: :index

  def index
    Services::Command::Drivers.fetch(success, failure)
  end

  def show
    Services::Command::Driver.new(id: id).fetch(success, failure)
  end

  private

  def authorize_driver
    raise Error404 unless Driver.exists?(id: id)
  end

  def id
    params[:id]
  end
end
