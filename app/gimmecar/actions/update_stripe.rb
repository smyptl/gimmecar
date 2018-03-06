class Actions::UpdateStripe

  def self.execute
    Driver.where.not(stripe_id: nil).each do |d|
      cu = Stripe::Customer.retrieve(d.stripe_id)
      cu.description = d.name
      cu.email = d.email
      cu.save
    end
  end
end
