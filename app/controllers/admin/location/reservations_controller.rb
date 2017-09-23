class Admin::Location::ReservationsController < Admin::Location::BaseController

  def index
    render status: 200, json: Services::Admin::Location::Reservations.fetch(location.id)
  end

  def new
  end

  def show
  end
end
