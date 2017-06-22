class Admin::Location::Rentals::CloseController < Admin::Location::Rentals::BaseController

  def index
  end

  def create
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Admin::Location::Rental::Close.new(params.require(:close)).execute(success, failure, params)
  end
end
