module Actions::Admin::Location::Rental::New::Concerns::FinancialResponsibility
  extend ActiveSupport::Concern

  included do
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
  end
end
