class Admin::Location::QuoteController < Admin::Location::BaseController

  def index
  end

  def show
    Services::Admin::Location::Quote.new(params.require(:quote)).retrieve(success, failure, location: location)
  end
end
