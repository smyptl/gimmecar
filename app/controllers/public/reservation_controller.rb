class Public::ReservationController < ApplicationController

  before_action :authorize_api

  def index
    Services::Public::GetRates.new(params.permit(:location_id, :vehicle_type, :pickup, :drop_off)).retrieve(success, failure)
  end

  def create
    Actions::Public::CreateReservation.new(params).execute(success, failure)
  end

  private

  def authorize_api
    raise ApplicationController::Error403 unless request.xhr?
  end
end
