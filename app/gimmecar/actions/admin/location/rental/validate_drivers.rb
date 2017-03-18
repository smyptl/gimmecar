class Actions::Admin::Location::Rental::ValidateDrivers < Lib::Forms::Base
  include Lib::Forms::Actions
  include Actions::Admin::Location::Rental::Concerns::Driver

  def save
  end

  def success_args
  end
end
