class Actions::ReturnDeposit

  def initialize()
  end

  def execute
    Driver.where.not(stripe_id: nil).each do |d|
      cu = Stripe::Customer.retrieve(d.stripe_id)
      cu.description = d.name
      cu.email = d.email
      cu.save
    end
  end
end
