class Admin::Location::QuoteController < Admin::Location::BaseController

  def index
  end

  def create
    Services::Admin::Location::Quote.new(params).retrieve(success, failure, location_id: location.id)
  end
end
