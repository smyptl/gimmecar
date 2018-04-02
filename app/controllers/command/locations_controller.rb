class Command::LocationsController < Command::BaseController

  before_action :authorize_location, except: :index

  def index
    Services::Command::Location.retrieve(success, failure)
  end

  #def show
    #Services::Command::Rental.new(number: number).retrieve(success, failure)
  #end

  #private

  #def authorize_rental
    #raise Error404 unless ::Rental.exists?(number: number)
  #end

  #def number
    #params[:id]
  #end
end
