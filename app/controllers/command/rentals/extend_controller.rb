class Command::Rentals::ExtendController < Command::Rentals::BaseController

  def index
    Services::Command::Rental::Extend.new(number: number).retrieve(success, failure)
  end

  def create
    Actions::Command::Rental::Extend.new(params.require(:extend).merge(number: number)).execute(success, failure)
  end
end
