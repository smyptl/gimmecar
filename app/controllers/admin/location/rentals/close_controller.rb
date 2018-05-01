class Admin::Location::Rentals::CloseController < Admin::Location::Rentals::BaseController

  def index
  end

  def create
    Actions::Admin::Location::Rental::Close.new(params).execute(success, failure, number: number)
  end
end
