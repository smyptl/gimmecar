class ApplicationMailer < ActionMailer::Base
  include ActionView::Helpers::NumberHelper

  helper_method :format_percent, :format_currency, :format_time, :format_date

  default from: 'GimmeCar | 24/7 Car Rental <team@gimmecar.com>'
  layout false

  def format_percent(value)
    "#{value*100}%"
  end

  def format_currency(value)
    number_to_currency(value/100, {precision: 2})
  end

  def format_time(value)
    value.strftime("%m/%d/%Y @ %I:%M:%S %p")
  end

  def format_date(value)
    value.strftime("%m/%d/%Y")
  end
end
