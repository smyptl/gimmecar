class AfterDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    date = record.instance_exec(&options[:with])

    return if options[:allow_nil] && date.nil?
    raise ArgumentError if date.nil?

    record.errors.add(attribute, (options[:message] || "must be after #{date.strftime('%m/%d/%Y')}")) unless value.after?(date)
  end
end
