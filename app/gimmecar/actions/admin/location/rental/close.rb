class Actions::Admin::Location::Rental::Close < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :drop_off
    a.integer :drop_off_odometer
    a.integer :drop_off_fuel
  end

  def save
  end
end
