class Admin::Location::RatesController < Admin::Location::BaseController

  def index
  end

  def show
    Actions::Admin::Location::Rates::Show.new(params.require(:rate)).execute(success, failure, { location: location })
  end
end
