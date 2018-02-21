class Admin::Location::QuoteController < Admin::Location::BaseController

  def index
  end

  def show
    Actions::Admin::Location::Quote.new(params.require(:quote)).execute(success, failure, location: location)
  end
end
