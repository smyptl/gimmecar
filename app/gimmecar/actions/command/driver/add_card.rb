class Actions::Command::Driver::AddCard < Lib::Actions::Base

  attributes do |a|
    a.integer :driver_id
    a.string  :token
  end

  validates :token,
    presence: true

  private

  def success_args
    {
      message: 'Card added.'
    }
  end

  def valid?
    if super
      begin
        driver.retrieve_or_create_stripe_customer.sources.create(source: token)
      rescue Stripe::CardError => e
        errors.add(:token, e.message)
        false
      else
        true
      end
    end
  end

  def save
  end

  def driver
    @driver ||= Driver.find(driver_id)
  end
end
