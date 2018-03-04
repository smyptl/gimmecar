class Actions::Admin::Location::Rental::New::ValidateDrivers < Lib::Forms::Base
  include Actions::Admin::Location::Rental::New::Concerns::Driver

  attributes do |a|
    a.time :drop_off
  end

  def pickup
    Time.now
  end

  def save
  end

  def success_args
  end
end
