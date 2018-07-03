class Actions::LowercaseDriverInfo < Lib::Actions::Base

  attributes do |a|
    a.integer :id
  end

  def success_args
    {}
  end

  private

  def save
    driver = Driver.find(id).tap do |d|
      d.name_first  = d.name_first.titielize
      d.name_last   = d.name_last.titielize
      d.name_middle = d.name_middle.titielize
      d.save
    end

    driver.addresses.each do |a|
      a.street1 = a.street1.titleize
      a.city    = a.city.titleize
      a.save
    end

    driver.insurance_policies.each do |i|
      i.company_name = i.company_name.titleize
    end
  end
end
