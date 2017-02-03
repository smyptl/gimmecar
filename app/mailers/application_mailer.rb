class ApplicationMailer < ActionMailer::Base
  include Roadie::Rails::Automatic
  include ActionView::Helpers::NumberHelper

  helper_method :format_percent, :format_currency, :format_date_time, :format_date

  default from: 'GimmeCar | Car Rentals <team@gimmecar.com>'
  layout 'email'

  def format_percent(value)
    "#{value*100}%"
  end

  def format_currency(value)
    number_to_currency(value/100, {:precision => 2})
  end

  def format_date_time(value)
    value.strftime("%m/%d/%Y @ %I:%M:%S %p")
  end

  def format_date(value)
    value.strftime("%m/%d/%Y")
  end
end
