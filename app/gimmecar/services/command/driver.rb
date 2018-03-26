class Services::Command::Driver < Lib::Services::Base

  attributes do |a|
    a.integer :id
  end

  output do
    object :driver do |o|
      o.component Services::Builders::Driver

      o.collection :insurance_policies do |c|
        c.attributes :company_name, :policy_number, :effective_date, :expiration_date
      end
    end
  end


  private

  def query
    ::Driver.includes(:insurance_policies).find(id)
  end
end
