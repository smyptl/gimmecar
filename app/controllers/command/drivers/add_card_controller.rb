class Command::Drivers::AddCardController < Command::Drivers::BaseController

  def create
    Actions::Command::Driver::AddCard.new(driver_id: id, token: params.fetch(:token)).execute(success, failure)
  end
end
