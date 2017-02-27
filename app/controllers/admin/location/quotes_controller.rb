class Admin::Location::QuotesController < Admin::Location::BaseController

  def index
  end

  def show
    success = lambda do |args|
      render status: 200, :json => args
    end

    failure = lambda do |args|
      puts args
      render status: 400, :json => args
    end

    Services::Admin::Quote.new(params.require(:quote)).execute(success, failure)
  end
end
