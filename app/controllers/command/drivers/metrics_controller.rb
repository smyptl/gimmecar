class Command::Drivers::MetricsController < Command::Drivers::BaseController

  def index
    Services::Command::Driver::Metrics.new(id: id).retrieve(success, failure)
  end
end
