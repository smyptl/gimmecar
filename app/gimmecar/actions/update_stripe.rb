class Actions::UpdateStripe < Lib::Actions::Base

  def success_args
    {}
  end

  private

  def save
    Driver.where.not(stripe_id: nil).includes(:emails, :email_primary).each do |driver|
      cu             = driver.stripe_customer
      cu.description = driver.name
      cu.email       = (driver.email_primary || driver.emails.frist).email
      cu.save
    end
  end
end
