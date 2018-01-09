class SignatureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Rails.env.test?

    unless !value.blank? && value.start_with?('data:image/png;base64')
      record.errors.add attribute, (options[:message] || 'signature required')
    end
  end
end
