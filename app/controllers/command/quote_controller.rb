class Command::QuoteController < Command::BaseController

  def index
    Services::Command::Locations.retrieve(success, failure)
  end

  def create
    Services::Command::Quote.new(params.require(:quote)).retrieve(success, failure)
  end
end
