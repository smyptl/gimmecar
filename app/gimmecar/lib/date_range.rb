class Lib::DateRange

  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    if end_date.before?(start_date)
      raise ArgumentError, "Start date cannot be before end date."
    end

    @start_date, @end_date = start_date, end_date
  end

  def include?(date)
    (start_date..end_date).cover?(date)
  end

  def days_apart
    ((end_date.to_time - start_date.to_time)/1.day.second).to_i
  end

  def hours_apart
    ((end_date.to_time - start_date.to_time)/1.hour.second).to_i
  end
end
