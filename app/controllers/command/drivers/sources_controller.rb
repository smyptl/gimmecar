class Command::Drivers::SourcesController < Command::Drivers::BaseController

  def index
    Services::Command::Driver::Sources.new(id: id).retrieve(success, failure)
  end
end
