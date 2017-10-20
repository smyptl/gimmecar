class Actions::Admin::Location::Rental::New::ValidateTermsAndConditions < Lib::Forms::Base

  attributes do |a|
    a.boolean :add_additional_driver
    a.signature :driver_signature
    a.signature :additional_driver_signature
  end

  validates :driver_signature,
    signature: true

  with_options if: :add_additional_driver do |a|
    a.validates :additional_driver_signature,
      signature: true
  end

  def save
  end

  def success_args
  end
end
