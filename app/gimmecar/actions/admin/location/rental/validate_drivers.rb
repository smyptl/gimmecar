class Actions::Admin::Location::Rental::ValidateDrivers < Lib::Forms::Base
  include Actions::Admin::Location::Rental::Concerns::Driver

  attributes do |a|
    a.date_time :drop_off
  end

  def pickup
    DateTime.now
  end

  def save
  end

  def success_args
  end
end
