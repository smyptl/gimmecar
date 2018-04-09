class Command::Drivers::InsurancePoliciesController < Command::Drivers::BaseController

  def index
    Services::Command::Driver::InsurancePolicies.new(id: id).retrieve(success, failure)
  end
end
