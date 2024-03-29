class Command::Rentals::ReturnDepositController < Command::Rentals::BaseController

  def index
    Services::Command::Rental::ReturnDeposit.new(number: number).retrieve(success, failure)
  end

  def create
    Actions::Command::Rental::ReturnDeposit.new(params.merge(number: number)).execute(success, failure)
  end
end
