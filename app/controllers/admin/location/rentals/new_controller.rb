class Admin::Location::Rentals::NewController < Admin::Location::BaseController

  def rates
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Services::Admin::Rental::Rates.new(params.require(:rental).permit(:pickup, :drop_off)).execute(success, failure, params)
  end

  def driver
  end

  def additional_driver
  end

  def add_ons
  end

  def summary
  end
end
