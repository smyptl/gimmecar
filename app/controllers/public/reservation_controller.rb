class Public::ReservationController < ApplicationController

  def index
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => { :errors => args.fetch(:errors) }
    end

    Services::Public::GetRates.new(params.permit(:pickup_date, :pickup_time, :drop_off_date, :drop_off_time)).execute(success, failure)
  end

  def create
  end
end
