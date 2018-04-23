class Command::QuoteController < Command::BaseController

  def index
    Services::Command::Locations.retrieve(success, failure)
  end

  def create
    Services::Command::Quote.new(params).retrieve(success, failure)
  end
end
