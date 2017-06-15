class Public::ReservationController < ApplicationController

  before_action :authorize_api

  def index
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Public::GetRates.new(params.permit(:pickup, :drop_off)).execute(success, failure)
  end

  def create
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Public::CreateReservation.new(params.require(:reservation)).execute(success, failure)
  end

  private

  def authorize_api
    raise ApplicationController::Error403 unless request.xhr?
  end
end
