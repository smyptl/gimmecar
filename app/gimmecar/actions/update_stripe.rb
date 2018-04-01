class Actions::UpdateStripe < Lib::Actions::Base

  def success_args
    {}
  end

  def save
    Driver.where.not(stripe_id: nil).each do |driver|
      cu             = driver.stripe_customer
      cu.description = driver.name
      cu.email       = driver.email
      cu.save
    end
  end
end
