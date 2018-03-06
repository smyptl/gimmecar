class Actions::Admin::Location::Rental::New::ValidateDrivers < Lib::Actions::Base
  include Actions::Admin::Location::Rental::New::Concerns::Driver

  attributes do |a|
    a.time :drop_off
  end

  def pickup
    Time.current
  end

  def save
  end

  def success_args
  end

  def time_zone
    @time_zone ||= Location.find(params[:location_id]).time_zone
  end
end
