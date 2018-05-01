class Admin::Location::Rentals::CloseController < Admin::Location::Rentals::BaseController

  def index
    Services::Admin::Location::Rental::Close.new(number: number).retrieve(success, failure)
  end

  def create
    Actions::Admin::Location::Rental::Close.new(params).execute(success, failure, number: number)
  end
end
