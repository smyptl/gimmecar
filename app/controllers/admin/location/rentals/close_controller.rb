class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def index
  end

  def create
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Services::Admin::Location::Rental::Close.new(params.require(:close)).execute(success, failure, params)
  end
end
