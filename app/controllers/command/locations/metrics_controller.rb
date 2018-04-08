class Command::Locations::MetricsController < Command::Locations::BaseController

  def index
    Services::Command::Location::Metrics.new(slug: slug).retrieve(success, failure)
  end
end
