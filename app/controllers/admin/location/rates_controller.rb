class Admin::Location::RatesController < Admin::Location::BaseController

  def index
    render status: 200, json: Services::Admin::Location::Rates.new(location.id).during_period(params[:start_date], params[:end_date]).fetch
  end

  def update
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      render status: 400, :json => args
    end

    Actions::Admin::Location::Rates::Update.new(params.require(:edit)).execute(success, failure, { location: location })
  end
end
