class Actions::Admin::Location::Rental::Create < Lib::Forms::Base
  include Lib::Forms::Actions

  attributes do |a|
    a.date_time :drop_off
  end

  def save
  end
end
