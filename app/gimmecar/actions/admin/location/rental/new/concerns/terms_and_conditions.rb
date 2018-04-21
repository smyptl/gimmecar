module Actions::Admin::Location::Rental::New::Concerns::TermsAndConditions
  extend ActiveSupport::Concern

  included do
    attributes do |a|
      a.boolean   :add_additional_driver
      a.signature :driver_signature
      a.signature :additional_driver_signature
    end

    validates :driver_signature,
      signature: true

    with_options if: :add_additional_driver do |a|
      a.validates :additional_driver_signature,
        signature: true
    end
  end
end
