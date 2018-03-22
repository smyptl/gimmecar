class Actions::UpdateStripe

  def self.execute
    Driver.where.not(stripe_id: nil).each do |driver|
      cu = driver.retrieve_stripe_customer
      cu.description = d.name
      cu.email = d.email
      cu.save
    end
  end
end
