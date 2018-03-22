class Actions::Command::Drivers::AddCard < Lib::Actions::Base

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

  def save
    customer = driver.retrieve_or_create_stripe_customer
    customer.sources.create(source: token)
  end

  def driver
    @driver ||= Driver.find(driver_id)
  end
end
