class AfterDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    byebug
  end
end
