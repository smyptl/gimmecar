class Command::Drivers::AddContactInfoController < Command::Drivers::BaseController

  def create
    Actions::Command::Driver::AddContactInfo.new(params).execute(success, failure, driver_id: id)
  end
end
