class Admin::Location::Rentals::ExtendController < Admin::Location::Rentals::BaseController

  def index
    Services::Command::Rental::Extend.new(number: number).retrieve(success, failure)
  end

  def create
    Actions::Command::Rental::Extend.new(params.merge(number: number)).execute(success, failure)
  end
end
