class Command::RatesController < Command::BaseController

  def index
  end

  def show
    Actions::Command::Rates::Show.new(params.require(:rate)).execute(success, failure)
  end
end
