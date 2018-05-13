class Lib::DateRange

  attr_reader :start_date, :end_date

  def initialize(start_date, end_date, time_zone: 'UTC')
    if end_date.before?(start_date)
      raise ArgumentError, 'Start date cannot be before end date.'
    end

    if start_date.class != end_date.class
      raise ArgumentError, 'Start date and end date not same class type.'
    end

    @start_date, @end_date = case start_date
                             when Time || ActiveSupport::TimeWithZone
                               convert_to_same_time_zone(start_date, end_date, time_zone: time_zone)
                             when Date
                               start_date, end_date
                             else
                               raise NotImplementedError
                             end
  end

  #def range
    #start_date..end_date
  #end

  #def each_date(*args, &block)
    #range(*args, &block)
  #end

  #def include?(date)
    #range.cover?(date)
  #end

  def days_apart
    ((end_date.to_time - start_date.to_time)/1.day.second).to_i
  end

  def hours_apart
    ((end_date.to_time - start_date.to_time)/1.hour.second).to_i
  end

  private

  def convert_to_same_time_zone(start_date, end_date, time_zone:)
    start_date.in_time_zone(time_zone), end_date.in_time_zone(time_zone)
  end
end
