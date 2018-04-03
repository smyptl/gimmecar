class Command::Locations::RevenueController < Command::Locations::BaseController

  def index
    Services::Command::Location::Revenue.new(slug: slug).retrieve(success, failure)
  end
end
