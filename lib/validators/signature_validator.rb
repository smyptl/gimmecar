class SignatureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if Rails.env.test?

    record.errors.add attribute, (options[:message] || 'signature required') unless value.start_with?('data:image/png;base64')
  end
end
