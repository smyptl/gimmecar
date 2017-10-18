class Actions::Admin::Location::Rental::New::ValidateFinancialResponsibility < Lib::Forms::Base

  attributes do |a|
    a.boolean :add_additional_driver
    a.signature :driver_financial_responsibility_signature
    a.signature :additional_driver_financial_responsibility_signature
  end

  validates :driver_financial_responsibility_signature,
    signature: true

  with_options if: :add_additional_driver do |a|
    a.validates :additional_driver_financial_responsibility_signature,
      signature: true
  end

  def save
  end

  def success_args
  end
end
