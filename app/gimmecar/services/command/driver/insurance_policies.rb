class Services::Command::Driver::InsurancePolicies < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    collection :insurance_policies do |c|
      c.attributes :company_name, :policy_number, :effective_date, :expiration_date
    end
  end

  private

  def query
    ::Driver.includes(:insurance_policies).find(id).insurance_policies
  end
end
