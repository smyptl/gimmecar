class Command::Controller < Command::BaseController

  def index
    Services::Command::Locations.retrieve(success, failure)
  end

  def show
    Services::Command::Quote.new(params.require(:quote)).execute(success, failure)
  end
end
